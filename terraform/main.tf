provider "aws"{
    region = "us-west-2"
}
resource "aws_ecs_cluster" "my_cluster" {
    name = "ecm"
}
resource "aws_iam_role" "ecs_task_execution_role" {
    name = "ecsTaskExecutionRole"
    assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Effect    = "Allow",
      },
    ],
  })
    managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]
}
resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-task"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([{
    name      = "my-python-microservice"
    image     = "510576647015.dkr.ecr.us-west-2.amazonaws.com/my-python-microservice:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
}
resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["<subnet-1>", "<subnet-2>"]
    security_groups = ["<security-group>"]
    assign_public_ip = true
  }
}
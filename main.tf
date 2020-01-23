provider "aws" {
    access_key = "key"
    secret_key = "key"
    region = "us-east-2"
    
}

resource "aws_instance" "tomcat" {
    ami = "ami-0d03add87774b12c5"
    instance_type = "t2.micro"
    security_groups = ["openjnks"]
    key_name = "karthiklinx"
    
    tags = {
        Name = "tomcat"
    } 

    connection {
        type = "ssh"
        user = "ubuntu"
        host = "${aws_instance.tomcat.public_ip}"
        private_key = "${file("./karthiklinx.pem")}"
    }

     provisioner "remote-exec" {
        inline = ["sudo apt-get update",
        "sleep 10",
        "sudo apt-get install openjdk-8-jdk -y",
        "sleep 10",
        "sudo apt-get install tomcat8 -y",
        "sleep 10",
        "sudo apt-get update"]
    }

  
}


resource "aws_instance" "mongoDB" {
    ami = "ami-0d5d9d301c853a04a"
    instance_type = "t2.micro"
    key_name = "karthiklinx"
    security_groups = ["openjnks"]

    tags = {
        Name = "mongoDB"
    } 

    connection {
        type = "ssh"
        user = "ubuntu"
        host = "${aws_instance.mongoDB.public_ip}"
        private_key = "${file("./karthiklinx.pem")}"

        
    }

    provisioner "remote-exec" {
        inline = ["wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -",
        "echo 'deb [ arch=amd64 ] http://repo.mongodb.com/apt/ubuntu bionic/mongodb-enterprise/4.2 multiverse' | sudo tee /etc/apt/sources.list.d/mongodb-enterprise.list",
        "sudo apt-get update",
        "sleep 10",
        "sudo apt-get install -y mongodb-enterprise"]
    }

  
}










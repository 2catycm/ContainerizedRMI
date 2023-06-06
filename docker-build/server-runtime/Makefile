server-runtime: Dockerfile
	docker build -t server-runtime:latest .
Dockerfile:
	spack containerize > Dockerfile
clean:
	rm Dockerfile
	docker rmi server-runtime:latest
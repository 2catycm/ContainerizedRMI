intel-compiler_mpi: Dockerfile
	docker build -t intel-compiler_mpi:latest .
Dockerfile:
	spack containerize > Dockerfile
	# https://blog.csdn.net/Olivia_Vang/article/details/104081096
	# https://github.com/openssl/openssl/issues/11021
	# sed -i "10 a RUN apk add --no-cache linux-headers" Dockerfile

clean:
	rm Dockerfile
	docker rmi intel-compiler_mpi:latest
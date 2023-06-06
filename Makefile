# 启动compose
compose-up: run-registry run-server run-client

compose-down: 
	docker stop registry server client || docker rm registry server client

submodules: Simple-MPI-Matmul SUSTechRMI

SUSTechRMI:
	git submodule update --init --recursive
Simple-MPI-Matmul:
	git submodule update --init --recursive


images: intel-compiler_mpi server registry client sustech-rmi server-runtime

# cd命令在Makefile中只在当前行生效, https://blog.csdn.net/weixin_38890593/article/details/89500105
# https://myprogrammingnotes.com/entering-directory-leaving-directory-messages-make-output.html
intel-compiler_mpi: 
	cd docker-build/intel-compiler_mpi/ && make

server-runtime:
	cd docker-build/server-runtime/ && make

# https://zhuanlan.zhihu.com/p/513402227
server:
	cd docker-build/server/ && docker build -t server:latest -f Dockerfile ../.. 

# https://blog.csdn.net/Flag2920/article/details/114390137
# https://stackoverflow.com/questions/43460770/docker-windows-container-memory-limit
# https://docs.docker.com/config/containers/resource_constraints/
run-server:
	docker run -itd --rm --cpuset-cpus 0-31 --name server --net=container:registry server:latest


registry:
	cd docker-build/registry/ && docker build -t registry:latest -f Dockerfile ../..

run-registry:
	docker run -itd --rm --name registry --net=bridge registry:latest

client:
	cd docker-build/client/ && docker build -t client:latest -f Dockerfile ../..

run-client:
	docker run -it --rm --name client --net=container:registry client:latest


sustech-rmi:
	cd SUSTechRMI/ && docker build -t sustech-rmi:latest -f Dockerfile .


clean:
	cd docker-build/intel-compiler_mpi/ && make clean
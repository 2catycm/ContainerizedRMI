submodules: Simple-MPI-Matmul SUSTechRMI

SUSTechRMI:
	git submodule update --init --recursive
Simple-MPI-Matmul:
	git submodule update --init --recursive


images: intel-compiler_mpi server

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
	docker run -it --rm --cpuset-cpus 0-31 --name server server:latest


sustech-rmi:
	cd SUSTechRMI/ && docker build -t sustech-rmi:latest -f Dockerfile .


clean:
	cd docker-build/intel-compiler_mpi/ && make clean
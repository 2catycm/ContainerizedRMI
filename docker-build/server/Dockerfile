# 第一阶段 构建MPI程序
# FROM intel-compiler_mpi:latest as matmul-builder
FROM intel/oneapi-hpckit:2023.1.0-devel-ubuntu22.04 as matmul-builder
# RUN apt-get update && apt-get install -y python3
COPY Simple-MPI-Matmul /root/Simple-MPI-Matmul
# RUN python3 -m pip install tqdm && cd /root/Simple-MPI-Matmul && python3 make.py
RUN cd /root/Simple-MPI-Matmul && python3 make.py

# 第二阶段 构建RMI服务端

FROM maven:3.6.3-jdk-11-slim@sha256:68ce1cd457891f48d1e137c7d6a4493f60843e84c9e2634e3df1d3d5b381d36c AS rmi-builder
RUN mkdir /project
COPY SUSTechRMI /project
WORKDIR /project
RUN mvn clean package -DskipTests

# 第三阶段 部署MPI程序和RMI服务端
FROM server-runtime:latest 
# 使用Dockerfile所在的操作系统的源作为镜像内的源
# COPY /etc/apt/sources.list /etc/apt/sources.list
# COPY ../sources.list /etc/apt/sources.list
# https://blog.csdn.net/weixin_45067618/article/details/122234387 必须用add
# RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
# ADD ../sources.list /etc/apt/
# 如果不指定from，一定是context https://docs.docker.com/engine/reference/builder/#copy
# context指定后，是相对于docekrfile的路径还是相对于context的路径？
# ADD docker-build/sources.list /etc/apt/

# https://blog.csdn.net/qq_43753724/article/details/122463902
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
&& sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list\
&& apt-get clean\
&& apt-get update


RUN apt-get update && apt-get install -y dumb-init
RUN mkdir /app
# RUN addgroup --system javauser && adduser -S -s /bin/false -G javauser javauser
RUN addgroup --system javauser && adduser --system --shell /bin/false --ingroup javauser javauser

# 复制MPI程序
# COPY --from=build 
COPY --from=matmul-builder  /root/Simple-MPI-Matmul/out/*.exe /app
# COPY ../../Simple-MPI-Matmul/out/*.exe /app
# ADD ../../Simple-MPI-Matmul/out/*.exe /app

# 复制RMI服务端
COPY --from=rmi-builder /project/target/*.jar /app

WORKDIR /app
RUN chown -R javauser:javauser /app
USER javauser
# CMD ["mpiexec", "-np", "2", "/app/mpi_matmul_peer_pattern_125.exe"]
# CMD mpiexec -np 2 -ppn 1 /app/mpi_matmul_peer_pattern_125.exe
# CMD mpiexec -np 2 /app/mpi_matmul_peer_pattern_4000.exe

# https://www.cnblogs.com/MrVolleyball/p/10177568.html
CMD ["dumb-init", "java", "-cp", "*.jar", "demo.matmul.ServerApp"]
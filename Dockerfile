# to find all the supported docker tags: https://hub.docker.com/_/python/
FROM python:3.6-slim

# or build-essential in the second command
RUN apt-get update && apt-get install build-essential -y && apt-get install unixodbc unixodbc-dev -y && apt-get install git -y && apt-get install wget -y && apt-get install tree -y

# So that we lp_solve can look for its files in these directories. Also need to link (ln -svf command)
ENV LP_LIBRARY_PATH /usr/local/lib:/usr/lib/lp_solve/lp_solve_5.5

# set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the contetns of the workdir above
ADD . /app

# Install any needed packages specified in requirements
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Install LP_Solve for Python 3.6
RUN mkdir -p /usr/lib/lp_solve/ && cd /usr/lib/lp_solve/ \
	&& wget -O ./lp_solve.tar.gz http://sourceforge.net/projects/lpsolve/files/lpsolve/5.5.2.0/lp_solve_5.5.2.0_source.tar.gz/download \
	&& tar -xf lp_solve.tar.gz \
	&& git clone https://github.com/nazariyv/lp_solve_python_3x.git \
	&& mkdir -p /usr/lib/lp_solve/lp_solve_5.5/extra/Python \
	&& cp -R /usr/lib/lp_solve/lp_solve_python_3x/extra/Python/ /usr/lib/lp_solve/lp_solve_5.5/extra/ \
	&& cd /usr/lib/lp_solve/lp_solve_5.5/lpsolve55 && chmod a+x ccc && sh ccc \
	&& ln -svf /usr/lib/lp_solve/lp_solve_5.5 /usr/lib/lp_solve/lp_solve_5.5/lpsolve55/bin/ux64 \
	&& cd /usr/lib/lp_solve/lp_solve_5.5/extra/Python && python setup.py install \
	&& rm -rf /usr/lib/lp_solve/lp_solve.tar.gz && rm -rf /lp_solve_python_3.x

# Make port 80 available to the world outside this container
EXPOSE 80

# Run app.py when the container launches (to prove that I have installed the required dependancies correctly
CMD ["python", "app.py"]

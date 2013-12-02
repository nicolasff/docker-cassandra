Docker setup for Apache Cassandra
=================================

This repository contains a set of scripts and configuration files to run a Cassandra cluster
from [Docker](https://www.docker.io/) containers. The current version of this repository is
configured to create a Cassandra 1.2 or 2.0 image and cluster.

Cassandra nodes are created with their own IP address and configured hostname:

    $ ./start-cluster.sh 3
    Starting node 1
    Starting node 2
    Starting node 3
    
    $ ./client.sh 2.0.3 nodetool -h cass1 status
    Datacenter: datacenter1
    =======================
    Status=Up/Down
    |/ State=Normal/Leaving/Joining/Moving
    --  Address        Load       Tokens  Owns   Host ID                               Rack
    UN  192.168.100.3  40.84 KB   256     34.9%  9d4a223f-e80e-4b50-b379-0705b1c8971d  rack1
    UN  192.168.100.1  38.93 KB   256     33.7%  5128dcb0-14d0-4d17-9b53-acc8f9a0844b  rack1
    UN  192.168.100.2  30.92 KB   256     31.4%  8e6faaba-601f-4812-a33b-05ceaecf1159  rack1

Note that the nodes might take about 30 seconds to show up as they join the Cassandra ring.

Getting started
---------------

### 1. Check out this repository

    $ git clone https://github.com/nicolasff/docker-cassandra.git
    $ cd docker-cassandra

### 2. Install pipework

Make sure that the bundled script `pipework` is in your path. You can install it with:

    $ sudo cp install/bin/pipework /usr/bin/

The latest version is on GitHub at https://github.com/jpetazzo/pipework.

### 3. Create a Docker image for Cassandra

To create a Cassandra 2.0.3 image and tag it, run:

	$ sudo make image VERSION=2.0.3

You should then see it appear in your list of Docker images:

    $ sudo docker images
    REPOSITORY          TAG                 ID                  CREATED              SIZE
    cassandra           2.0.3              b9ba84a33bb5        About a minute ago   12.29 kB (virtual 404.7 MB)

### 4. Start a cluster

Run `./start-cluster.sh 2.0.3 3` to create a cluster of 3 nodes running Cassandra 2.0.3. They are given an IP address and name each, from `cass1` (`192.168.100.1`) to `cass3` (`192.168.100.3`).

Run `sudo docker ps` to list your Cassandra nodes:

    $ sudo docker ps
    ID                  IMAGE               COMMAND                CREATED             STATUS              PORTS
    99d67692f535        cassandra:2.0.3    /usr/bin/start-cassa   10 minutes ago      Up 10 minutes       49332->9160         
    fe7e2b13cb9e        cassandra:2.0.3    /usr/bin/start-cassa   10 minutes ago      Up 10 minutes       49331->9160         
    f21da380b00c        cassandra:2.0.3    /usr/bin/start-cassa   10 minutes ago      Up 10 minutes       49330->9160  

### 5. Connect to your cluster

Cassandra nodes expose port 9160 for Thrift. Use `sudo docker port <container-id> 9160` or `sudo docker ps` to find the local port it is mapped to.

`client.sh` creates a docker container with access to the Cassandra cluster network (`192.168.100.0/24`). The first client is given the name `cass254`
with IP `192.168.100.254`, the next one `cass253`, etc. Names are reused when client containers are stopped.

`client.sh` runs any command that is passed to it, e.g. `nodetool`, `cassandra-cli`, `cqlsh`... You can also open a shell with `./client.sh 2.0.3 bash`.

### 6. Terminate your cluster

	$ ./stop-cluster.sh 2.0.3
    Killing and removing containers 99d67692f535 fe7e2b13cb9e f21da380b00c
    
    $ sudo docker ps
    ID                  IMAGE               COMMAND             CREATED             STATUS              PORTS

Licensing and contributions
---------------------------

This set of scripts and configuration files is released under the [Apache 2.0 License](https://github.com/nicolasff/docker-cassandra/blob/master/LICENSE).
`pipework` is Copyright 2013 [Jérôme Petazzoni](https://github.com/jpetazzo) and distributed under the Apache 2.0 license.

Contributions and suggestions welcome [on GitHub](https://github.com/nicolasff/docker-cassandra/issues) or [on Twitter](https://twitter.com/yowgi).

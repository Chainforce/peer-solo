## Peer Solo

This is a very simple network consisting of an orderer running solo consensus 
and a peer. It includes a cli container to interact with the peer using 
peer commands.

The chaincode directory containing the example02 from Fabric. You may want to 
replace it with your own chaincode.

## Starting Up

The network is configured with ``crypto-config.yaml`` and stored in ``crypto-config``.

To regenerate the configuration, simply run ``gen-config.sh``. This script uses
the binaries from ``make release``, which deposits the executables in 
``release/darwin-amd64/bin``. If you have these executables at a different
place, set the ``PATH`` accordingly in ``gen-config.sh``.

To start the network, run ``start.sh``. This script starts up the docker
containers and creates a channel ``mychannel`` configured with ``configtx.yaml``.
It also deploys the example02 chaincode.

Once the network is up, you may interact with it by enter the cli container,
``docker start cli && docker exec -it cli bash``

The following cli commands operate on chaincode (replace the inputs as appropriate):

Install:  ``peer chaincode install -n mycc -v 1.0 -p github.com/example02/``

Instantiate:  ``peer chaincode instantiate -o orderer.example.com:7050 -C mychannel -n mycc -v 1.0 -c '{"Args":["init","a", "100", "b","200"]}'``

Query:  ``peer chaincode query -C mychannel -n mycc -c '{"Args":["query","a"]}'``

Invoke:  ``peer chaincode invoke  -C mychannel -n mycc -c '{"Args":["invoke","a","b","10"]}'``

## Shutting Down

To stop the network and clean up everything, run ``stop.sh``

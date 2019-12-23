#  安装

```
docker run -dit --name eth -h eth \
	-v /etc/localtime:/etc/localtime:ro \
 	-v /data/eth_date:/root/.ethereum \
 	-p 30303:30303 -p 8545:8545 \
  	--restart=always \
	ethereum/client-go:stable  --rpc --rpcaddr "0.0.0.0" \
  	--rpcapi "web3,eth,net,db,personal" --maxpeers=50 --rpccorsdomain "*"
```

#  使用

##  预备

- geth help
- geth version
- geth dumpconfig 查看启动默认参数

##  步骤

1.   创建创世纪

   ```
   geth --datadir ~/gdata/data0 init genesis.json console
   ```

2.   启动

   ```
   //--config *.toml
   //
   //--identity  容易在节点列表中表示
   //
   //--datadir默认为 ~/.ethereum/
   //
   //--networkid 默认值是1即主网络, 其他网络只能不是1  只有相同的
   //
   //--port 30303 用来监听其他节点端口
   //
   //三种api  httprpc websocket ipc(unixsocket|pipe)
   //--wsapi  监听事件时需使用
   //
   //--ipcpath
   //--ipcapi admin, eth, miner
   //
   //--rpc    启动http rpc, 默认只启动本地ipc通道
   //--rpcapi 默认为web3 geth启动http rpc时是禁止admin,debug等模块，而想要通过remix调试solidity就需要这些权限
   //--rpccorsdomain "*" 允许跨域访问，否则http://ethereum.github.io/在对http://localhost:8545进行 http rpc通信时会被浏览器阻塞
   //
   //--allow-insecure-unlock 默认rpc http是不安全的，不能通过rpc http unlockAccount
   //
   //--fast --cache=1024 默认全节点同步模式 fast只下载状态(download status)
   //
   //--nodiscover 不使用discover protocol协议来找节点  你的节点不会被其他人发现,除非手动添加
   //--bootnodes "enode://$pubkey1@ip1:port1 enode://pubkey2@ip2:port2 enode://pubkey3@ip3:port3"
   //--admin.addPeer("enode://pubkey@ip:port")
   //
   //--mine   //能够mine
   //--mine --minerthreads=4 //设置并行挖矿的线程数,默认为所有的处理器数, 之后可以通过miner.start(8)修改 使用8个minerthreads挖矿
   //--mine --etherbase '0xd5b6413db58fa011d311cc3d79d40b7497c7d1b3' 
   //--mine --etherbase 1  //1为eth.accounts中的序号,从1开始
   
   geth  --identity "TestNode" --networkid 66  \
   --datadir ~/gdata/data0  \
   --port 30303 \
   --mine \
   --rpc --rpcaddr 0.0.0.0 --rpcport 8545 --rpcapi "web3,eth,net,db,personal,debug,admin" \
   --rpccorsdomain "*" \
   --nodiscover \
   --allow-insecure-unlock \
   console  2>console.log
   ```

3.   登录

   三种登录方式

   ```
   命令行 geth geth account list
   控制台 console
   http geth attach http://127.0.0.1:8545 --datadir
   ws geth attach ws://127.0.0.1:8545 --datadir
   ipc geth attach data/01/geth.ipc --datadir
   脚本方式
   ```

4.  创建账户

   ```
   personal.newAccount('111111'); //括号中为密码返回的是账户地址
   ```

5.  挖矿

   ```
   miner.start();
   eth.mining;  //检查是否在挖矿
   ```

6. 

#  命令行web3

```
web3
	//单位换算
	eth.getBalance(eth.accounts[0])  //返回的是wei
	//web3.toWei(1,'ether')
	web3.fromWei(eth.getBalance(eth.accounts[0]),'ether')
net//查看p2p网络状态
	net.listening
admin //管理节点
	admin.nodeInfo.enode
	admin.peers
	admin.addPeer("enode://$enode@ip:port")
personal//管理账户
	personal.listAccounts  等价于 eth.accounts
	personal.listWallets 可以查看是否locked状态
	personal.newAccount('password123')          非交互方式geth --password $password_file account new //密码以明文方式写在$password里
	//修改密码 geth account update $address
	//导入账户 geth account import <keyfile> 
	//导入钱包 geth wallet import <etherwallet.json>
	personal.unlockAccount(eth.accounts[0],"111111");
eth
	eth.accounts //查看账户
	eth.coinbase //查看挖矿账户
	eth.getBalance(eth.coinbase)  //eth.accounts[0] //查看余额
	eth.blockNumber //查看高度
	eth.syncing //查看同步状态， 返回false表示未同步或同步到最新了
	eth.mining //查看是否在挖矿 true是 false否
	//查看指定区块
	eth.getBlock('latest')
	eth.getBlock().miner   //块的挖矿者
	eth.getBlockTransactionCount('pending')
	eth.getBlock('pending', true).transactions
	//查看指定交易及回执
	eth.getTransaction('$hash')
	eth.getTransactionReceipt('$hash')
	//转账
	eth.sendTransaction({from:eth.accounts[0],to:"$addr2",value:web3.toWei(100,"ether")})
miner//挖矿
	miner.setEthbase(eth.accounts[0]) //设置挖矿账户
	miner.start()
	miner.stop()
txpool//交易池
	txpool.status
	txpool.inspect.pending
```

#  客户端web3js

##  安装

- npm install web3 官网 <https://web3js.readthedocs.io/en/v1.2.2/>
- npm install truffle 官网 <https://www.trufflesuite.com/docs/truffle/quickstart>
- solidity <https://solidity.readthedocs.io/en/v0.5.12/index.html>

```
$>truffle version
Truffle v5.0.44 (core: 5.0.44)
Solidity - 0.5.1 (solc-js)
Node v10.12.0
Web3.js v1.2.2
```

##  使用

###  初始化产生truffle框架

```
mkdir truffletest && cd truffletest && truffle init
```

###  准备文件

####  编写主文件sol文件

####  确认配置文件

- 配置总体配置文件truffle-config.js 

  ```
  compilers: {
     development: {         //network名称
       network_id: "*",     //Any network (default: none) 可以设置为default
       websockets: true,    //如果有事件event,服务端必须以ws方式运行
      },
      solc: {
        version: "0.5.1", //决定了solc使用的版本 
        docker: false,    //是否使用docker
      }
    }
  ```

- 配置部署文件migrations/0_initial_migration.js

  按照truffle约定,文件名必须以数字为前缀 

  ```
  const Migrations = artifacts.require("Migrations");
  const Greeter = artifacts.require("Greeter");  //需要部署的合约 按照truffle的约定,文件名与合约名必须完全一致,即便是大小写
  
  module.exports = function (deployer) {
    // deployer.deploy(Migrations);
    deployer.deploy(Greeter, 88);  //从第二个参数起为合约的构造函数的参数
  };
  ```

####  编写测试文件test/a.js

```
//@ts-check
const Web3 = require('web3');
const fs = require('fs')

let ctx = JSON.parse(fs.readFileSync("./build/contracts/Greeter.json", 'utf8'));
let ABI = ctx["abi"]

// const web3 = new Web3('http://localhost:8545');
// let CONTRACT_ADDRESS = "0x157A7296915A2AA28251655dbBa9806b54aF6b3d"; 

const web3 = new Web3('ws://192.168.1.120:8545');
let CONTRACT_ADDRESS = "0xf619E9E0a553901fDf22A79C708E913d526E8c69";
const contract = new web3.eth.Contract(ABI, CONTRACT_ADDRESS);  //CONTRACT_ADDRESS是部署时获取的合约地址

console.log(web3.version);    //1.2.2

(async () => {
    const address = await web3.eth.personal.getAccounts();
    if (address.length <= 0) {
        throw new Error("no account");
    }
    let minerAddress = address[0]

    //解锁账户 
    // web3.eth.personal.unlockAccount(minerAddress, '111111', 600)
    //     .then(console.log("account unlocked"))         //.then(console.log)
    //     .catch((err) => { console.log(err) });


    // 业务set/get
    await contract.methods.setGreeting(44).send({ from: minerAddress });
    let ret = await contract.methods.greet().call()
    console.log("ret is " + ret);

    const blockNumber = await web3.eth.getBlockNumber()
    var eventFilter = contract.events.triggerevent({ fromBlock: blockNumber, }, function (error, event) {
        if (error) {
            console.log("merr1 " + error);
        } else {
            console.log("evnet1 " + event);
            console.log(event);
        }
    })
        .on("connected", function (subscriptionId) {
            console.log("connected" + subscriptionId);
        })
        .on('data', function (event) {
            console.log("data " + event); // same results as the optional callback above
            console.log(event);
        })
        .on('changed', function (event) {
            console.log("changed " + event);
        })
        .on('error', console.error);


})();


// let accounts = (async () => {
//     // let  arr;

//     await delay(400);
//     console.log("aaaaa");

//     let result = await web3.eth.getAccounts();
//     // await web3.eth.getAccounts().then((r)=>{
//     //     arr = r;
//     //     console.log("11" + r);
//     // })
//     return result;
//     // console.log("get acccouts " + accounts);
// })();


// function delay(ms) {
//     const promise = new Promise((resolve, reject) => {
//         setTimeout(() => {
//             resolve("sddddf");
//         }, ms);
//     });
//     return promise;
// }

// web3.eth.personal.getAccounts().then(console.log)
// let getAddress = async function() {
//     const address = await web3.eth.personal.getAccounts()
//     console.log(address)
//     console.log(address.length)
//     console.log(typeof address)
//     console.log(typeof address[0])
//     console.log("-----")
//     return address[0]
// }

// const unlockAccount = async () => {
//     const address = await getAddress()
//     console.log(address)
//     console.log(typeof address)
//     web3.eth.personal.unlockAccount(address,'111111',600).then(console.log("account unlocked"))
// }
// unlockAccount()
```

###  编译

```
 truffle compile [--compile-all] //默认只compile自上次编译以来修改过的文件
                                 //--compile-all重新编译所有文件
```

###  部署

```
truffle migrate [--reset --network development ] //network是truffle-config.js中配置的
                                                 //reset 全新部署
```

###  测试

```
truffle test [/path/to/test/file --verbose-rpc]
```


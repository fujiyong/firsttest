
geth export filename //导出文件
geth import filename //导入文件


公有测试网络
	Ropsten网络
		同步区块geth --testnet --fast --bootnodes ""
		进入网络geth --testnet 
	Rinkeby archive full ligth embeded4种模式




//



#node testweb3.js
#cat testweb3.js
const fs = require("fs")
const solc = require('solc')

var web3 = require("web3")
if (typeof web3 !== 'undefined') {
	web3 = new Web3(web3.currentProvider);
}else{
	web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}
let from = web3.eth.accounts[0];

//编译合约
let source = fs.readFileSync("a.sol","utf-8");
let calcCompiled = web3.eth.compile.solidity(source);

console.log(calcCompiled)
console.log("abi definition:")
console.log(calcCompiled["info"]["abiDefinition"]);

//得到合约对象
let abiDefinition = calcCompiled["info"]["abiDefinition"];
let calContract = web3.eth.contract(abiDefinition);

//部署合约
let deployCode = calcCompiled["code"]
let deployAddr = web3.eth.accounts[0];

let myConstractRet = calContract.new([contructorParam1][,contructorPara2],{
	data: deployCode,
	from: deployAddr,
	gas: 1000000,
}, function(err, myContract){
	if (!err){
		if (!myContract.address){
			console.log("contract deploy transaction hash: " + myContract.transactionHash) //部署合约的交易哈希值
		}else{
			console.log("contract deploy address: " + myContract.address) // 合约的部署地址

		}
	}
});

//从一个已知的部署地址获取合约
let contractAddr = myConstractRet.address
let calContractInstance = calContract.at(contractAddr)

// Automatically determines the use of call or sendTransaction based on the method type
myContractInstance.myMethod(param1 [, param2, ...] [, transactionObject] [, defaultBlock] [, callback]);

// 不修改区块链上的数据,不消耗gas  Explicitly calling this method
myContractInstance.myMethod.call(param1 [, param2, ...] [, transactionObject] [, defaultBlock] [, callback]);

// 修改区块链上的数据,需要消耗gas  Explicitly sending a transaction to this method
// transactionObject = {from: deployeAddr, to: destAddr, value:携带的货币量:, gas:交易使用的gas量,gasPrice:, data:,nonce:}
myContractInstance.myMethod.sendTransaction(param1 [, param2, ...] [, transactionObject] [, callback]);

// Get the call data, so you can call the contract through some other means
var myCallData = myContractInstance.myMethod.getData(param1 [, param2, ...]);
// myCallData = '0x45ff3ff6000000000004545345345345..'



let source = fs.readFileSync("a.sol", 'utf8');
let compiledContract = solc.compile(source, 1);
let abi = compiledContract.contracts['nameContract'].interface;
let bytecode = compiledContract.contracts['nameContract'].bytecode;
let gasEstimate = web3.eth.estimateGas({data:bytecode})
let MyContract = web3.eth.constract(JSON.parse(abi));


//async deploy
var myContractReturned = MyContract.new(param1, param2,{
	from: mysendAddress,
	data: bytecode,
	gas: gasEstimate,
},function(err, myContract){
    if(!err) {
       // NOTE: The callback will fire twice!
       // Once the contract has the transactionHash property set and once its deployed on an address.

       // e.g. check tx hash on the first call (transaction send)
       if(!myContract.address) {
           console.log(myContract.transactionHash) // The hash of the transaction, which deploys the contract

       // check address on the second call (contract deployed)
       } else {
           console.log(myContract.address) // the contract address
       }

       // Note that the returned "myContractReturned" === "myContract",
       // so the returned "myContractReturned" object will also get the address set.
});


//sync deploy
// Deploy contract syncronous: The address will be added as soon as the contract is mined.
// Additionally you can watch the transaction by using the "transactionHash" property
var myContractInstance = MyContract.new(param1, param2, {data: myContractCode, gas: 300000, from: mySenderAddress});
myContractInstance.transactionHash // The hash of the transaction, which created the contract
myContractInstance.address // undefined at start, but will be auto-filled later




Remix的安装
	git clone https://github.com/ethereum/browser-solidity
	cd browser-solidity
	npm install
	npm run prepublish
启动
	npm start
访问
	http://127.0.0.1:8080


合约
	{data:字节码 to:null} 由minerbase旷工打包加入区块链，产生一个合约账户 合约地址 代码保存到合约账户中
	//data 前32个字节为具体函数 后32个字节为参数
	//to   智能合约








SOLIDITY  静态类型


值类型  每次都是复制
	bool
	byte
	int8 int256  uint8 uint256  int默认为int256 uint默认为uint256
	enum 默认从0开始 只能进行显式转化，不能隐式   enum SomeEnum {ONE,  TWO, THREE}  没有后面的";",使用的时候是SomeEnum.TWO
	address
	固定长度字节数组
		增
		删  长度不变 元素为0
		查
		改
引用类型  storage(默认状态变量与部分复杂类型的局部变量(数组结构体))/memory(函数参数或其他简单类型的局部变量)
	数组  T[k]  T[]  由于EVM的限制,外部函数调用无法返回一个动态长度的数组,只能先将其放置在一个足够长的定长数组中再返回
		length storage中数组可以修改length成员改变数组长度, memory中的数组已经确定不能修改
		增push() //返回新长度
		删     数组长度为0
		查[]
		改[] //下标访问
	bytes
		bytes1  ...  bytes32  
		bytes(str)
		length
		增push() //可以直接push,不用new确定长度,类似于golang中的append()函数,即使第一个参数是null,也可直接push; 返回新长度
		删
		查[]//下标访问
		改
	string
		//不能length [] 如遇到求length,可以bytes(s).length
		string(bytes)
	映射
		mapping(KType=>VType)  //k并不存储键的数据,而是其keccak-256()      K不能是map 动态数组 enum struct这些类型
		所有可能存在的键都有一个默认值,默认值得二进制编码全为0,所以映射并没有长度的概念
		增
		删  ?
		查  ? 
		改
		遍历 由于key不是明文存储,不能遍历,不过可以将所有的key保存到不定长数组中然后遍历
	结构体
		struct{}
操作符
	new
		int[] memory a = new int[](3);
		a[0] = 0; a[1]=1; a[2]=2;
	delete  赋值运算,使对象的值重新为初始值
		不能作用于map
		作用于数组元素arr[n]，则只将这个数组元素置为空   number为0 string为"" bytes为0x0
		作用于固定长度数组 则数组长度不变但元素都重置为0
		作用于不定长度数组 则数组长度为0
		作用于struct, 则递归作用于除map之外的成员
控制解构与语句
	不支持switch goto
	if else if else
	for while do while
	break continue
	?:
隐式/显式(强制)转换
	contractInstance = $ContractName($ContractAddress);  //不会调用$ContractName的构造函数
类型自动推导
	uint x = 3; var y = x  //y为uint  类似于C++的auto
内置单位
	货币1eth=1*10**18wei  1eth finney szabo gwei mwei kwei wei
		wei 默认 finney szabo ether
	时间
		seconds 默认 minutes hours days weeks days years
函数 
	不能返回变长长度的值(dynamic type如T[],string), 必须临时复制到定长数组再返回定长数组
	多个参数 多个返回值  当没有对返回值赋值时,默认为0
	命名调用 f({k:3, v:2})

	加密函数
		addmod(uint x, uint y, uint k) returns (uint)  //(x+y)%k
		mulmod(uint x, uint y, uint k) returns (uint)  //(x*y)%k
		keccak256(...) return (bytes32)
		sha3(...) returns (bytes)  //keccak256的别名
		sha256(...) returns (bytes) //sha-256散列值
		ripemd160(...) returns (bytes) //
		ecrecover()
	全局函数
		selfdestruct(address recipient) //销毁当前合约 并且将全部的以太币余额转到作为参数传入的地址
		suicide(address recipt): selfdestruct函数的别名  过时
异常ex
	assert(bool) //非真时抛出异常
	require(bool) //用于处理输入或来自外部模块
	revert()  //中断程序执行并且退回状态改变
	throw
类/contract
	关键字is
	多重继承      从左往右   都是虚函数,除非指定类名,否则调用的都是派生类的函数
	关键字super
	构造函数
		contract Base{
			uint x;
			function Base(uint _x) { x = _x;}
		}
		contract Derived is Base(7) {      //在继承列表中直接指定,一般当基类构造函数为常量时
			function Derived(uint y) Base(y*y){ //在派生类构造函数时指定,一般当基类构造函数为变量时   2中构造函数同时存在时,第二种生效
			}
		}
	可见性
		函数默认为public; 状态变量默认为interal,并且不可为external
		exteranl 外部函数      只能由其他合约调用
		public   函数默认/变量
		internal 函数/变量默认  当前合约或继承当前合约的子合约调用   类似于C++的protected
		private  函数/变量      当前合约
	constant/view/pure关键字函数   只读操作,不会造成状态的变化   类似于C++的const函数
		造成状态变化: 修改变量的值  触发事件 创建其他合约 调用非constant函数等
		constant为了误导语言中常量的定义,在solidity5.0去掉了,用vew代替,  成员函数只能读,不能修改状态
		pure 既不能读状态,也不能改状态
	fallback函数  默认存在的函数, 无参无返回值  默认行为是抛出异常
		触发时机自动调用fallback()函数
			调用一个不存在的函数
			仅仅用于转账的交易时
		原来 function fallback() {throw;}
		改写 function () payable {} //无名无参无返回值, 无名是可选

	函数修改器Function Modifiers
		主要是在函数执行前或执行后插入逻辑
		可以继承,也可以被派生类重写  类似于python的装饰器      分无参函数修饰器和含参函数修饰器

	constract Register is priced, owner {  //is 多重继承
		//增加了indexed的参数会存储到日志结构的topic部分,以便快速查找;
		//    但如果是参数是数组类型(bytes string),则topic只存储经过web3.sha3()哈希值,不是原始数据
		//    因为topic是为了快速查找,不能存任意长度的数据,所以非固定长度的数据需要经过hash
		//未增加indexed的参数会存储到日志结构的data部分,成为原始日志
		//事件函数签名为第一个主题,也是默认主题keccak256("Deposit(address,address,uint256)")
		//如果参数是数组(bytes string)被设置为indexed,则会使用对应的keccak-256散列值作为主体.
		event Deposit(address indexed _from, bytes32 indexed _id, uint256 _value); //定义事件  每个事件最多使用3个indexed关键字设置索引
		mapping(adderss => bool) registeredAddresses;
		// mapping(uint => mapping(bool => uint[])) data;
		uint price;

		function Register(uint initPrice) priced() owner(){ //构造函数
			price = initPrice;
		}

		function registe() payable costs(price) { //使用含参函数修饰器  只要涉及到钱都要payable
			registeredAddresses[msg.sender] = true;
			Deposit(msg.sender, 0, msg.value);   //触发事件
		}

		function getPrice() constant return (uint)  {return price;}  //constant

		modifier onlyOwner() { require(msg.sender == owner; xxxx; _; yyyy;}    //定义无参函数修饰器 _指代被修改的函数体 在这之前执xxxx,在这之后执行yyyy
		modifier costs(uint price) { if (msg.value >= price) { _;}}  //定义含参函数修饰器

		function foo() returns (bool) {}  //为什么在web3中无法使用返回值? 这样的函数只能被合约其他函数调用使用返回值,这样的函数只能使用事件被web3监听到.

		function () payable{}   //手动实现 重写fallback()函数
	}

	抽象合约 可以继承,但不能实例化, 约定一些功能
		contract  Feline{
			function foo() return (byte32); //没有函数实现 类似于C++的纯虚函数
		}
事件与日志
	为何使用事件: 因为涉及到transaction时,立即返回返回的只是交易的hash值,并没有确定上链,上链是一个耗时的过程.为了立即使用结果,这里使用了事件.
	当触发事件时,会将事件及其参数写入到日志中,并与合约账户绑定. 区块在,日志就在,但日志无法在合约中访问,即使是创建该日志的合约.
	触发事件产生存储日志,需要消耗storage,而消耗storage是需要微量的gas的.
	日志是一种相比合约存储的一种低成本存储。日志每字节花费8gas，然而合约存储每32字节花费20000gas。
	logi(事件的data部分msg._value,第一个topic即函数签名,第二个topic即参数中第一个为indexed的,第三个topic即参数中第二个参数为indexed的)
	var abi = "";//由编译器生成
	var Funding = web3.eth.contract(abi);
	var funding = Funding.at("0x123"); //部署后生成的合约地址
	var defaultTopic = web3.sha3("Deposit(address,address,uint256)");
	//只监测Deposit
	//过滤事件 第一个参数是函数原来的具有index属性的参数列表; 第二个参数是与原函数参数无关的固定参数
	//	增加了indexed关键字的参数值会存储到日志的topic部分,未添加indexed的会存储到日志的data部分;topic部分添加了索引以便快速查找,data部分未添加索引;但存储到topic的不一定是原始值,如bytes和string等不定长数据,会经过hash再存储
	var eventFilter = funding.Deposit({_value:[100,200]},{fromblock:0,toblock:'latest',topics:[defaultTopic],address:[]});  //事件函数名() 不必传入实参 返回value==100/200的从第一块到最后一块的过滤后的事件
	eventFilter.Watch(function(error, result){
		if (!error){
			for(let k in result){
				console.log(k + ":" + result[k]);
			}
		}
	});
	var eventFilter = funding.Deposit(function(error, result){
		if (!error){
			for(let k in result){
				console.log(k + ":" + result[k]);
			}
		}
	});
	eventFilter.stopWatching();
	//监测所有事件
	var eventFilter = funding.allEvents({fromblock:0, toblock:'latest'});
	eventFilter.watch(function(error, result){});
	eventFilter.get(function(error, logs){});
	eventFilter.stopWatching();
全局变量
	this //指代当前合约  从solidity0.5.0开始,合约this不再继承地址类型,但仍可以显式转换为地址   address owner = this;
address  20个字节
	balance                     //uint wei

	如果一个函数需要进行货币操作,哪怕是查询,必须带上payable关键字,这样才能正常接收msg.value
	transfer(uint256 )          //wei     会throw ex     addressA.transfer(2 ether)  addressA是接收方,向addressA转账2 ether
	send(uint256) return (bool) //wei 会默认关联函数fallback()(如果这个函数存在) 这是EVM的默认行为,不可阻止.
										//如果通过send()发送,则必须指定fallback()函数,否则会抛出异常
										//fallback()函数必须增加payable关键字,否则send()执行的结果必定是false

	call(methodid, arg1,...,argN) return (bool)         //发起底层call指令 失败返回false  函数名的字符串, 任意个数的任意类型的参数 call函数的每个参数没填充到32个字节并拼接在一起
	                                                    //但当第一个参数的长度恰好是4个字节,则该参数不会打包成32个字节,而是作为函数的签名
									//bytes4 methodid = bytes4(keccak256("function_name(arg1type, arg2type,...,argNtype)"))
	delegatecall() return (bool) //委托调用
	callcode() return (bool)     //发起底层callcode指令  更早期时才使用, 比call拥有更低的权限,无法访问msg.sender msg.value等变量
消息msg
	data   //bytes 完整的调用数据
	gas    //uint  表示剩余的gas
	sender //address
	sig    //bytes4 调用数据的前4字节 函数标识符
	value  //uint 转账的以太币数
区块block
	blockhash(uint blocknumber) returns (bytes32)  //不包括当前区块的最近256个区块有效
	coinbase   return (bytes32)  //当前区块矿工的账号地址
	difficulty     //uint 当前区块难度
	gaslimit       //uint 当前区块gas限制
	number         //uint 当前区块编号
	timestamp      //uint unit时间戳 当前区块产生的时间
	now  //uint 表示当前时间 是block.timestamp的别名
交易tx
	tx.gasprice //uint 表示当前交易的gas价格
	tx.origin   //address 表示完整调用链的发起者







pragma solidity ^0.5.12;


contract VIP{
    enum Status {UNSET, DISABLED, ENABLED}
    
	address payable owner;
	mapping(address=>address) accounts;   //邀请人=>推荐者
	mapping(address=>Status)  vips;
	
	event triggerevent(address indexed active, address indexed passive, string eventcontent);
 
    // function VIP(){
    //     owner = msg.sender;
    // }
    constructor() public{
        owner = tx.origin;
        accounts[owner] = owner;
        vips[owner] = Status.ENABLED;
    }
    
    function New(string memory vds_user, address new_vip_svds_address) public returns (bool){
		require(msg.sender == owner);
		accounts[new_vip_svds_address] = owner;
		vips[new_vip_svds_address] = Status.ENABLED;
        return true;
	}
	
	
	function Recommend(address old_vip_address) public payable returns (bool) {
		if (vips[old_vip_address] == Status.ENABLED ){
			accounts[msg.sender] = old_vip_address;
			return true;
		}
		return false;
	}

	//如果一个函数需要操作eth,必须带上payable关键字,这样才能正常接收msg.value
	function TransferCoin(address payable dst_addresses, uint money) public payable returns (bool){
		if (msg.sender.balance < money) { return false;}
		dst_addresses.transfer(money); //向dst_addresses转账msg.value个wei
		emit triggerevent(msg.sender, dst_addresses, "i invite to recommend me to be vip");
		return true;
	}

	function IsVIP(address tested_address) public view returns (address){
		if (vips[tested_address] == Status.ENABLED){
			return accounts[tested_address];
		}
		return address(0x0);
	}

	function DisableVIP(address vip_address) public returns (bool) {
		require(msg.sender == owner);
		if ( vips[vip_address] == Status.ENABLED ){
			vips[vip_address] = Status.DISABLED;
			return true;
		}
		return false;
	}

	function EnableVIP(address dis_vip_address) public returns (bool){
		require(msg.sender == owner);
		if (vips[dis_vip_address] ==  Status.DISABLED){
			vips[dis_vip_address] = Status.ENABLED;
			return true;
		}
		return false;
	}
    
}

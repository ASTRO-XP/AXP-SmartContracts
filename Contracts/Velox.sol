// SPDX-License-Identifier: MIT
// File: math/SafeMath.sol

pragma solidity ^0.8.0;

library SafeMath {

    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {

            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }
    
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

// File: token/erc20/IERC20.sol

pragma solidity ^0.8.0;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// File: Contracts/ERC20/utils/Context.sol

pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: Contracts/ERC20/IERC20.sol

pragma solidity ^0.8.0;
interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// File: Contracts/ERC20/extensions/IERC20Metadata.sol

pragma solidity ^0.8.0;
interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

// File: token/erc20/ERC20.sol

pragma solidity ^0.8.0;

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }
    function name() public view virtual override returns (string memory) {
        return _name;
    }
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        unchecked {
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}


// File: token/erc20/ERC20GatewayWhitelist.sol

pragma solidity 0.5.17;


contract ERC20GatewayWhitelist is ERC20 {
  address public mainchainGateway;

  function allowance(address _owner, address _spender)
    public
    view
    returns (uint256 _value)
  {
    if (_spender == mainchainGateway) return uint256(-1);

    return _allowance[_owner][_spender];
  }

  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    returns (bool _success)
  {
    if (allowance(_from, msg.sender) != uint256(-1)) {
      super._approve(_from, msg.sender, _allowance[_from][msg.sender].sub(_value));
    }

    _transfer(_from, _to, _value);
    return true;
  }

  function _setGateway(address _mainchainGateway) internal {
    require(
      _mainchainGateway != address(0),
      "ERC20GatewayWhitelist: setting gateway to the zero address"
    );
    mainchainGateway = _mainchainGateway;
  }
}

// File: access/HasAdmin.sol

pragma solidity 0.5.17;


contract HasAdmin {
  event AdminChanged(address indexed _oldAdmin, address indexed _newAdmin);
  event AdminRemoved(address indexed _oldAdmin);

  address public admin;

  modifier onlyAdmin {
    require(msg.sender == admin, "HasAdmin: not admin");
    _;
  }

  constructor() internal {
    admin = msg.sender;
    emit AdminChanged(address(0), admin);
  }

  function changeAdmin(address _newAdmin) external onlyAdmin {
    require(_newAdmin != address(0), "HasAdmin: new admin is the zero address");
    emit AdminChanged(admin, _newAdmin);
    admin = _newAdmin;
  }

  function removeAdmin() external onlyAdmin {
    emit AdminRemoved(admin);
    admin = address(0);
  }
}

// File: access/HasMinters.sol

pragma solidity 0.5.17;



contract HasMinters is HasAdmin {
  event MinterAdded(address indexed _minter);
  event MinterRemoved(address indexed _minter);

  address[] public minters;
  mapping (address => bool) public minter;

  modifier onlyMinter {
    require(minter[msg.sender]);
    _;
  }

  function addMinters(address[] memory _addedMinters) public onlyAdmin {
    address _minter;

    for (uint256 i = 0; i < _addedMinters.length; i++) {
      _minter = _addedMinters[i];

      if (!minter[_minter]) {
        minters.push(_minter);
        minter[_minter] = true;
        emit MinterAdded(_minter);
      }
    }
  }

  function removeMinters(address[] memory _removedMinters) public onlyAdmin {
    address _minter;

    for (uint256 i = 0; i < _removedMinters.length; i++) {
      _minter = _removedMinters[i];

      if (minter[_minter]) {
        minter[_minter] = false;
        emit MinterRemoved(_minter);
      }
    }

    uint256 i = 0;

    while (i < minters.length) {
      _minter = minters[i];

      if (!minter[_minter]) {
        minters[i] = minters[minters.length - 1];
        delete minters[minters.length - 1];
        minters.length--;
      } else {
        i++;
      }
    }
  }

  function isMinter(address _addr) public view returns (bool) {
    return minter[_addr];
  }
}

// File: token/erc20/ERC20Mintable.sol

pragma solidity 0.5.17;


contract ERC20Mintable is HasMinters, ERC20 {
  function mint(address _to, uint256 _value) public onlyMinter returns (bool _success) {
    return _mint(_to, _value);
  }

  function _mint(address _to, uint256 _value) internal returns (bool success) {
    totalSupply = totalSupply.add(_value);
    balanceOf[_to] = balanceOf[_to].add(_value);
    emit Transfer(address(0), _to, _value);
    return true;
  }
}

// File: VELOX.sol

pragma solidity 0.5.17;





contract VELOX is ERC20Detailed, ERC20Mintable, ERC20GatewayWhitelist {
  constructor(address _mainchainGateway)
    public
    ERC20Detailed("VELOX", "VLX", 0)
  {
    _setGateway(_mainchainGateway);

    address[] memory _minters = new address[](1);
    _minters[0] = _mainchainGateway;
    addMinters(_minters);
  }
}
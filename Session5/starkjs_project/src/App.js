import "./App.css";
import { connect, disconnect } from "@argent/get-starknet";
import { useState, useEffect } from "react";
import { Contract } from "starknet";

import contractAbi from "./abis/abi.json";
const contractAddress =
  "0x077e0925380d1529772ee99caefa8cd7a7017a823ec3db7c003e56ad2e85e300";

function App() {
  const [connection, setConnection] = useState();
  const [account, setAccount] = useState();
  const [address, setAddress] = useState();

  const [retrievedValue, setRetrievedValue] = useState("");

  const connectWallet = async () => {
    const connection = await connect({
      webWalletUrl: "https://web.argent.xyz",
    });

    if (connection && connection.isConnected) {
      setConnection(connection);
      setAccount(connection.account);
      setAddress(connection.selectedAddress);
    }
  };

  const disconnectWallet = async () => {
    await disconnect();
    setConnection(undefined);
    setAccount(undefined);
    setAddress("");
  };

  const increaseCounter = async () => {};

  const decreaseCounter = async () => {};

  const getCounter = async () => {};

  return (
    <div className="App">
      <header className="App-header">
        <main className="main">
          <h1 className="title">
            Starknet<a href="#"> Counter</a>
          </h1>
          {connection ? (
            <button className="connect" onClick={disconnectWallet}>
              Disconnect
            </button>
          ) : (
            <button className="connect" onClick={connectWallet}>
              Connect wallet
            </button>
          )}
          <p className="description">{address ? address : "address"}</p>

          <div className="grid">
            <div href="#" className="card">
              <h2>Ensure to connect to Mainnet! &rarr;</h2>

              <p>Increase/Decrease Counter.</p>
              <div className="cardForm">
                <input
                  type="submit"
                  className="button"
                  value="Increase"
                  onClick={increaseCounter}
                />
                <input
                  type="submit"
                  className="button"
                  value="Decrease"
                  onClick={decreaseCounter}
                />
              </div>

              <hr />
              <div className="cardForm">
                <input
                  type="submit"
                  className="button"
                  value="Get Counter"
                  onClick={getCounter}
                />
                <p>{retrievedValue}</p>
              </div>
            </div>
          </div>
        </main>
      </header>
    </div>
  );
}

export default App;

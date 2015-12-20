import React, { Component } from 'react';
import spotify from 'spotify-node-applescript';
import { ipcRenderer } from 'electron';

console.log(ipcRenderer)

export default class Home extends Component {

  constructor(props) {
    super(props);

    this.state = {
      track: null,
      totalSeconds: 0,
      playTime: 0
    };

    this.next = this.next.bind(this);
  }

  getTrack() {
    ipcRenderer.send('asynchronous-message', 'ping');
  }

  componentWillMount() {
    ipcRenderer.on('asynchronous-reply', (event, track) => {
      console.log(event, track);
      const { duration } = track;
      const totalSeconds = duration / 1000;

      this.setState({
        track,
        totalSeconds
      });
    });
  }

  componentDidMount() {
    this.getTrack();

    setInterval(() => {
      this.setState({ playTime: this.state.playTime + 1});
    }, 1000);
  }

  next() {
    spotify.next((err) => {
      this.getTrack();
      this.setState({ playTime: 0});
      console.log(err);
    });
  }

  play() {
    spotify.play((err) => {
      console.log(err);
    });
  }

  pause() {
    spotify.pause((err) => {
      console.log(err);
    });
  }

  onSeek(e) {
    console.log(e);
    spotify.jumpTo(e.target.valueAsNumber, (err) => {
      console.log(err);
    });
  }

  render() {
    return (
      <div>
        <div>Playing: {JSON.stringify(this.state.track)}</div>
        <button onClick={this.next}>Next</button>
        <button onClick={this.play}>Play</button>
        <button onClick={this.pause}>Pause</button>
        <input
          type="range"
          // onChange={this.onSeek}
          min="0"
          max={this.state.totalSeconds}
          value={this.state.playTime} />
      </div>
    );
  }
}

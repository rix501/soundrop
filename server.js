import express from 'express';
import mongoose from 'mongoose';
import _ from 'lodash';

mongoose.Promise = global.Promise;
mongoose.connect(process.env.MONGOHQ_URL || 'mongodb://localhost/test');

const { Schema } = mongoose;

const app = express();

app.get('/health', (req, res) => {
  res.send('ok');
});

const server = app.listen(process.env.PORT || 9009, () => {
  const host = server.address().address;
  const port = server.address().port;

  console.log('Soundrop app listening at http://%s:%s', host, port);
});

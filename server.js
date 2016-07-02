import express from 'express';
import './server/db-config';
import './server/schemas';
import routes from './server/routes';

const app = express();

app.use(routes);

const server = app.listen(process.env.PORT || 9009, () => {
  const host = server.address().address;
  const port = server.address().port;

  console.log('Soundrop app listening at http://%s:%s', host, port);
});

import mongoose from 'mongoose';

mongoose.Promise = global.Promise;
mongoose.connect(process.env.MONGOHQ_URL || 'mongodb://localhost/test');

import mongoose from 'mongoose';

const { Schema } = mongoose;

export const Room = mongoose.model('Room', new Schema({
  name: String,
  tracks: [String]
}, { autoIndex: false }));

export const User = mongoose.model('User', new Schema({
  name: String
}, { autoIndex: false }));

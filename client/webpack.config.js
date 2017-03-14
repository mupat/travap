const path = require('path');
const dist = path.join(__dirname, "dist")

module.exports = {
  entry: './index.js',
  output: {
    path: dist,
    filename: 'app.js'
  },
  module: {
    rules: [
      {
        test: /\.jsx?$/,
        loader: 'babel-loader',
        exclude: /node_modules/,
      },
      {
        test: /\.html?$/,
        loader: 'file-loader?name=[name].[ext]'
      }
    ]
  },
  devServer: {
    contentBase: dist,
    compress: true,
    port: 5000
  },
  watch: true
};

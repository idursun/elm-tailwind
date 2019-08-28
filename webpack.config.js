const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const HTMLWebpackPlugin = require("html-webpack-plugin");
const path = require("path");

const mode = process.env.NODE_ENV || "development";
const prod = mode === "production";

module.exports = {
  entry: {
    bundle: ["./src/main.js"]
  },
  resolve: {
    modules: [path.join(__dirname, "src"), "node_modules"],
    extensions: [".js", ".elm", ".scss", ".png"]
  },
  output: {
    path: __dirname + "/public",
    filename: "[name].js",
    chunkFilename: "[name].[id].js"
  },
  module: {
    rules: [
        
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
            { loader: "elm-hot-webpack-loader" },
            {
                loader: "elm-webpack-loader",
                options: {
                    // add Elm's debug overlay to output
                    debug: true,
                    //
                    forceWatch: true
                }
            }
        ]
      },
      {
        test: /\.css$/,
        use: [
          /**
           * MiniCssExtractPlugin doesn't support HMR.
           * For developing, use 'style-loader' instead.
           * */
          MiniCssExtractPlugin.loader,
          {
            loader: "css-loader",
            options: {
              importLoaders: 1
            }
          },
          "postcss-loader"
        ]
      },
      {
        test: /\.jpe?g$|\.svg$|\.gif$|\.png$|\.ico$/i,
        loader: "url-loader",
        options: {
          name: "./img/[name].[ext]",
          limit: 10000
        } //Files greater than this size in bytes are not inlined.
      },
      {
        test: /\.otf$|\.woff$|\.woff2$|\.eot$|\.ttf$/,
        loader: "url-loader",
        options: {
          name: "./fonts/[name].[ext]",
          limit: 10000
        }
      }
    ]
  },
  mode,
  plugins: [
    new HTMLWebpackPlugin({
      // Use this template to get basic responsive meta tags
      template: "src/index.html",
      // inject details of output file at end of body
      inject: "body"
    }),
    new MiniCssExtractPlugin({
      filename: "[name].css"
    })
  ],
  devtool: prod ? false : "source-map"
};


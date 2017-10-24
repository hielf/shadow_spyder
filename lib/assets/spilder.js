var http = require('http');
var fs = require('fs');
var cheerio = require('cheerio');
var request = require('request');
var mysql = require('mysql');

const root = 'https://www.youtube.com';


var videoInfoList = [];
var nextPage;
var client;


//数据库连接
function connSql(){
  client = mysql.createConnection({
    user:'root',
    password:'user',
  });
  client.connect(function(err){
    if(err){
      console.log("database error");
      setTimeout(connSql,2000);
    }
  });

  client.on('error', function (err) {
    console.log('db error', err);
    if (err.code === 'PROTOCOL_CONNECTION_LOST') {
        connSql();
      }
    if (err.code === 'ECONNRESET') {
        connSql();
      }
    else {
        throw err;
      }
    });
  }
connSql();
client.query('use cars_video');

//得到每一页数据
function getAllVideo(url,sum,select,keyWord) {
  request(url,function(err,res){
    if(err){
      console.log(err);
      client.end();
    }else {
      console.log("==================new page===================")
      var $ = cheerio.load(res.body);
      nextPage = $('.branded-page-box').children().last().attr('href');
      getVdoInfo($,url,sum,select,keyWord);
    }
  })
}


function getVdoInfo(page,url,sum,select,keyWord) {
  var n = 0;
  var $ = page;
  for(let i = 0; i<sum;i++){
    let videoPageHref = $(select).eq(i).attr('href');
      if(videoPageHref == undefined){
        console.log('undefined')
        client.end();
        return false;
      }
      let videoInfo = {};
      videoInfo.href = root+videoPageHref;
      videoInfo.title = $('h3.yt-lockup-title').eq(i).find('a').text();
      // console.log(videoInfo.title);
      videoInfo.views = $('.yt-lockup-meta-info').eq(i).find('li').eq(1).text().replace(/[^0-9]/g,'');
      videoInfo.time = $('.yt-lockup-meta-info').eq(i).find('li').eq(0).text().split(' ');
      videoInfo.auther = $('.g-hovercard').eq(i).text();
      videoInfo.duration = $('#results .video-time').eq(i).text();
      videoInfo.key_word = keyWord;
      if(videoInfo.views>=2000){
        //if(videoInfo.time[1]=="個月前" && videoInfo.time[0]>6){
          //console.log('发布时间不是6个月以内');
        //}else{
          client.query('select id from video where src = ?',videoInfo.href,function(err,res){
            if(res!="") {
              console.log('已存在');
            }else{

              client.query('insert into video(src,name,author,pv,video_duration,key_word) values(?,?,?,?,?,?)',[videoInfo.href,videoInfo.title,videoInfo.auther,videoInfo.views,videoInfo.duration,videoInfo.key_word],function(err,res){
                if(err){
                  console.log(err);
                  console.log("错误数据");
                  return;
                }else{
                  console.log("加入成功");
                }
              })
            }
          });
        //}
      }else{
        console.log('浏览数小于2000');
      }

      if(n<19){
        n++;
      }else{
        nextPage!="undefined" ? getAllVideo(root+nextPage,20,'.yt-lockup-title a',keyWord):console.log(nextPage);
      }
    }
}

  let url = root + "/results?sp=EgIIBUgA6gMA&q=BMW+X5";
  url = encodeURI(url);
  getAllVideo(url,20,'.yt-lockup-title a','BMW X5');

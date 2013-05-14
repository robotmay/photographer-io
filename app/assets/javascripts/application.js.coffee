# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require jquery.masonry
#= require jquery.wookmark
#= require jquery.pjax
#= require s3_direct_upload
#= require foundation
#= require_tree .

$(document).foundation()

window.calculateGridWidth = ->
  width = $(window).width()
  switch
    when width > 768
      flexibleWidth = '20%'
    when width > 500
      flexibleWidth = '50%'
    else
      flexibleWidth = '100%'

window.wookmarkOptions = (itemWidth) ->
  {
    align: 'center',
    container: $(".photo-grid"),
    flexibleWidth: itemWidth
  }

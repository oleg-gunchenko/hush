<%@ page import="com.hbasebook.hush.ResourceManager" %>
<%@ page import="com.hbasebook.hush.HushUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.hbasebook.hush.model.Counter" %>
<%@ page import="com.hbasebook.hush.model.ShortUrl" %>
<%@ page import="com.hbasebook.hush.model.ShortUrlStatistics" %>
<%
  String username = HushUtil.getOrSetUsername(request, response);
  ResourceManager rm = ResourceManager.getInstance();
  String requestURI = request.getRequestURI() ;
  int endIndex = requestURI.lastIndexOf('/');
  if (endIndex < 0)
    endIndex = requestURI.length();
  String siteUrl = requestURI.substring(0, endIndex) ;
  String site = rm.getDomainManager().getDefaultDomain();
  List<ShortUrlStatistics> stats = rm.getCounters().getUserShortUrlStatistics(
    username);

  if (stats != null && stats.size() > 0) {
%>
<div id="userstats">
  <p>
  <table id="tbluserstats">
    <thead>
    <tr>
      <th>No.</th>
      <th>Short URL</th>
      <th>Long URL</th>
      <th>Trend (last 30d)</th>
    </tr>
    </thead>
    <tbody>
    <%
      int rowNum = 0;
        for (ShortUrlStatistics stat : stats) {
          rowNum++;
          ShortUrl shortUrl = stat.getShortUrl() ;
          String url = shortUrl.toString();
          String detailsUrl = siteUrl + "/" + shortUrl.getId() + "+";
          String longUrl = shortUrl.getLongUrl();
          StringBuffer sparkData = new StringBuffer();
          for (Object obj : stat.getCounters("clicks").descendingSet()) {
            Counter<Date, Double> counter = (Counter<Date, Double>) obj;
            if (sparkData.length() > 0) {
              sparkData.append(",");
            }
            sparkData.append(counter.getValue());
          }
    %>
    <tr>
      <td class="rowNum"><%=rowNum%></td>
      <td class="shortUrl"><a href="<%= detailsUrl %>"><%= url %></a></td>
      <td class="longUrl"><a href="<%= longUrl %>" target=""><%= longUrl %></a></td>
      <td class="trend"><a href="<%= detailsUrl %>">
        <img alt="Recent Trend for <%= url %>"
             src="http://chart.apis.google.com/chart?cht=ls&chs=120x15&chd=t:<%=sparkData%>&chco=999999&chm=B,999999,0,0,0&chds=0,120"/></a>
      </td>
    </tr>
    <%
      }
    %>
    </tbody>
  </table>
  </p>
</div>
<% } %>

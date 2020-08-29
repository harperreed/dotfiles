<?
$latlng = str_replace("\n",'',`whereami`);
$rgeo_url = 'http://maps.googleapis.com/maps/api/geocode/json?latlng='.$latlng.'&sensor=true';
$rgeo = @file_get_contents($rgeo_url);
$response = json_decode($rgeo);

if ($response->status=='OK'){
  print_r($response->results);
  $address = $response->results[0]->formatted_address;
  echo $address;
}

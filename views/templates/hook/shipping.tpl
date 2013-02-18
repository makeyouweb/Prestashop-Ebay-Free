<form action="{$formUrl}" method="post">

<fieldset>
	<legend>{l s='Global Configuration' mod='ebay'}</legend>
		<label>{l s='Delivery Time' mod='ebay'}</label>
		<div class="margin-form">
			<select name="deliveryTime" id="deliveryTime">
				{foreach from=$deliveryTimeOptions item=deliveryTimeOption}
					<option value="{$deliveryTimeOption.DispatchTimeMax}" {if $deliveryTimeOption.DispatchTimeMax == $deliveryTime} selected="selected"{/if}>{$deliveryTimeOption.description}</option>
				{/foreach}
			</select>
		</div>


		
</fieldset>
<script type="text/javascript">
	function addShippingFee(show, internationalOnly, idEbayCarrier, idPSCarrier, additionalFee){
		var currentShippingService = -1;
		lastId = $('#nationalCarrier tr').length;

		if(additionalFee == undefined)
			additionalFee = '';

		var stringShippingFee = "<tr>";
		stringShippingFee += "<td>{l s='Choose your eBay carrier'}</td>";
		stringShippingFee += 	"<td>";
		stringShippingFee += 		"<select name='ebayCarrier["+lastId+"]' id='ebayCarrier_"+lastId+"'>";
		{foreach from=$eBayCarrier item=carrier}
		currentShippingService = {$carrier.shippingServiceID};
		//check for international
		if((internationalOnly == 1 && '{$carrier.InternationalService}'=== 'true') || internationalOnly == 0)
		{
			if(currentShippingService == idEbayCarrier){
				stringShippingFee += 		"<option value='{$carrier.shippingServiceID}' selected='selected'>{$carrier.description}</option>";
			}
			else{
				stringShippingFee += 		"<option value='{$carrier.shippingServiceID}'>{$carrier.description}</option>";
			}
		}
		{/foreach}
		stringShippingFee += 		"</select>";
		stringShippingFee += 	"</td>";
		stringShippingFee += 	"<td>";
		stringShippingFee += 		"{l s='Associate it with a PrestaShop carrier'}";
		stringShippingFee += 	"</td>";
		stringShippingFee += 	"<td>";
		stringShippingFee += 		"<select name='psCarrier["+lastId+"]' id='psCarrier_"+lastId+"'>";
												{foreach from=$psCarrier item=carrier}
		currentShippingService = {$carrier.id_carrier};
		if(currentShippingService == idPSCarrier){
			stringShippingFee += 		"<option value='{$carrier.id_carrier}' selected='selected'>{$carrier.name}</option>";
		}
		else{
			stringShippingFee += 		"<option value='{$carrier.id_carrier}'>{$carrier.name}</option>";
		}
												{/foreach}
		stringShippingFee += 		"</select>";
		stringShippingFee += 	"</td>";
		stringShippingFee += 	"<td>";
		stringShippingFee += 		"{l s='Add extra fee for this carrier'}";
		stringShippingFee += 	"<td>";
		stringShippingFee += 	"<td>";
		stringShippingFee += 		"<input type='text' name='extrafee["+lastId+"]' value='"+additionalFee+"'>";
		stringShippingFee += 	"</td>";
		stringShippingFee += 	"<td>";
		stringShippingFee += 	"<img src='../img/admin/delete.gif' title='Delete' class='deleteCarrier' />";	
		stringShippingFee += 	"</td>";
		stringShippingFee += "</tr>";

		if(show == 1)
			$('#nationalCarrier tr:last').after(stringShippingFee);
		else
			return stringShippingFee;
	}

	function getShippingLocation(){
		string = '';
		{foreach from=$internationalShippingLocation item=shippingLocation}
		string += '<input type="checkbox" name="internationalShippingLocation" value="{$shippingLocation.location}">{$shippingLocation.description}</option>';
		{/foreach}
		return string;
	}

	function getExcludeShippingLocation(){
		string = "";
		string += "<select name=''>";
		{foreach from=$excludeShippingLocation item=shippingRegion key=region}
		string += "<option value='{$region}''>{$region}</option>";
			{foreach from=$shippingRegion item=shippingLocation}
				string += "<option value='{$shippingLocation.location}''>---{$shippingLocation.description}</option>";
			{/foreach}
		{/foreach}
		string += "</select>";
		return string;
	}

	function addInternationalShippingFee(idEbayCarrier, idPSCarrier, additionalFee)
	{
		string = "<div class='internationalShipping'>";
		string += "<table class='table'>";
		string += "<tr>";
		string += addShippingFee(0, 1);
		string += "</tr>";
		string += "</table>"
		string += "<label>{l s='Add eBay zone for this carrier' mod='ebay'}</label>";
		string += "<div class='margin-form'>"+getShippingLocation()+"</div>";
		string += "<label>{l s='Exclude eBay zone for the carrier'}</label>";
		string += "<span style='font-size:18px;font-weight:bold;padding-right:5px;' class='addExcludedZone' title='{l s='Add a new excluded zone' mod='ebay'}'>+</span>";
		string += '</div>';

		$('#internationalCarrier div.internationalShipping:last').after(string);

	}


	jQuery(document).ready(function($) {
		/* INIT */
		{foreach from=$existingNationalCarrier item=nationalCarrier}
			addShippingFee(1, 0, {$nationalCarrier.ebay_carrier}, {$nationalCarrier.ps_carrier}, {$nationalCarrier.extra_fee});
		{/foreach}
		

		/* EVENTS */
		$('#addNationalCarrier').click(function(){
			addShippingFee(1, 0);
			$('.deleteNationalCarrier').unbind().click(function(){
				$(this).parent().parent().remove();
			});
		});
		
		$('#addInternationalCarrier').click(function(){
			addInternationalShippingFee(1, 0);
			$('.deleteNationalCarrier').unbind().click(function(){
				$(this).parent().parent().remove();
			});
		});

		$('.deleteNationalCarrier').click(function(){
			$(this).parent().parent().remove();
		});
	});
</script>

<style>
.internationalShipping{
	background-color: #FFF;
	border: 1px solid #AAA;
	margin-bottom: 10px;
}
</style>



<fieldset style="margin-top:10px;">
	<legend>{l s='Shipping Method for National Shipping' mod='ebay'}</legend>

	<table id="nationalCarrier" class="table">
		<tr>
		</tr>
	</table>
	
	<div class="margin-form" id="addNationalCarrier" style="cursor:pointer;">
	<span style="font-size:18px;font-weight:bold;padding-right:5px;">+</span>{l s='Add a new Carrier option in eBay'}
	</div>
</fieldset>

<fieldset style="margin-top:10px">
	<legend>{l s='Shipping Method for Interational Shipping' mod='ebay'}</legend>	
	<div id="internationalCarrier">
		<div class="internationalShipping"></div>
	</div>
	<div class="margin-form" id="addInternationalCarrier" style="cursor:pointer;">
	<span style="font-size:18px;font-weight:bold;padding-right:5px;">+</span>{l s='Add a new international Carrier option in eBay'}
</fieldset>

<div class="margin-form" id="buttonEbayShipping" style="margin-top:20px;">
	<input class="button" name="submitSave" type="submit" id="save_ebay_shipping" value="Sauvegarder"/>
</div>


</form>

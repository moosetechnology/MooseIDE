"
I am a popup used by MiExportBrowser to select the columns to display and export.
I show all available properties for a MooseGroup and the ones displayed in the exporter are selected.
"
Class {
	#name : #MiExporterColumnsEditor,
	#superclass : #MiPresenter,
	#instVars : [
		'propertiesList',
		'exporter'
	],
	#category : #'Midas-Export'
}

{ #category : #specs }
MiExporterColumnsEditor class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #propertiesList withConstraints: [ :constraints | 
			  constraints
				  height: 250;
				  width: 250 ];
		  yourself
]

{ #category : #initialization }
MiExporterColumnsEditor >> initializePresenters [

	super initializePresenters.
	propertiesList := (self instantiate:
			                   MiFilteringSelectableListPresenter)
		                  display: [ :property | property name ];
		                  onActivation: [ :property | 
			                  exporter showProperties:
					                  propertiesList selectedItems ];
		                  onDeactivation: [ :property | 
			                  exporter showProperties:
					                  propertiesList selectedItems ].
	self setPropertiesListItems
]

{ #category : #initialization }
MiExporterColumnsEditor >> setModelBeforeInitialization: anExporter [

	exporter := anExporter
]

{ #category : #'as yet unclassified' }
MiExporterColumnsEditor >> setPropertiesListItems [

	| properties |
	properties := exporter miSelectedItem flatCollectAsSet: [ :entity | 
		              entity mooseDescription allPrimitiveProperties ].

	propertiesList items: (properties sorted: #name ascending).

	propertiesList selectItems:
		(propertiesList items select: [ :property | 
			 exporter showsProperty: property ])
]

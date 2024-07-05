Class {
	#name : #StMooseProcessor,
	#superclass : #StSpotterProcessor,
	#category : #'MooseIDE-Spotter'
}

{ #category : #'default-settings' }
StMooseProcessor class >> defaultEnabled [

	^ true
]

{ #category : #'default-settings' }
StMooseProcessor class >> order [
	
	^ 900
]

{ #category : #'default-settings' }
StMooseProcessor class >> title [

	^ 'Moose'
]

{ #category : #filtering }
StMooseProcessor >> newTextFilteringSource [

	^ ((StCollectionIterator on: (MooseModel root
			     ifEmpty: [ {  } ]
			     ifNotEmpty: [ :root | root anyOne allUsing: FamixTNamedEntity ]))
		   collect: [ :e | StMooseEntry on: e ]) asSubstringFilter
]

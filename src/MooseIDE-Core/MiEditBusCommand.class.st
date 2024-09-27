Class {
	#name : #MiEditBusCommand,
	#superclass : #MiPopupCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiEditBusCommand class >> defaultDescription [

	^ 'Edit buses'
]

{ #category : #default }
MiEditBusCommand class >> defaultIconName [

	^ #mooseEditor
]

{ #category : #default }
MiEditBusCommand class >> defaultName [

	^ 'Buses'
]

{ #category : #testing }
MiEditBusCommand >> canBeExecuted [

	^ self context canEditBuses
]

{ #category : #accessing }
MiEditBusCommand >> dynamicDescription [

	^ String streamContents: [ :s |
		  self context buses do: [ :bus |
			  s
				  << '- ';
				  << bus name;
				  cr ].
		  s << 'Click to edit' ]
]

{ #category : #accessing }
MiEditBusCommand >> dynamicName [

	^ self context buses ifEmpty: [ 'No bus' ] ifNotEmpty: [ :buses |
		  buses size = 1
			  ifTrue: [ 'Bus: ' , buses anyOne name ]
			  ifFalse: [ buses size asString , ' buses' ] ]
]

{ #category : #converting }
MiEditBusCommand >> popupContent [

	^ MiBusesPopup newApplication: self application model: self context
]

Class {
	#name : #MiEditBusCommand,
	#superclass : #MiCommand,
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

{ #category : #converting }
MiEditBusCommand >> asSpecCommand [

	| specCommand |
	specCommand := super asSpecCommand.

	specCommand buildPresenterBlock: [ :cmd |
		SpToolbarPopoverButtonPresenter new
			label: self name;
			help: self dynamicDescription;
			icon: specCommand icon;
			content: [ self busesList ];
			yourself ].

	^ specCommand
]

{ #category : #converting }
MiEditBusCommand >> busesList [

	| busesList |
	busesList := SpFilteringSelectableListPresenter newApplication:
		             self application.
	busesList addStyle: 'busesList'.
	busesList display: #name.
	busesList items: self application buses.
	busesList selectItems: context buses copy.

	busesList
		onActivation: [ :bus | bus ifNotNil: [ context followBus: bus ] ];
		onDeactivation: [ :bus | bus ifNotNil: [ context unfollowBus: bus ] ].

	"Do not filter bus use text input for bus creation"
	busesList filterInputPresenter placeholder: '+ New bus'.
	busesList itemFilter: [ :each :pattern |
		true "We do not want to filter anything" ].

	busesList filterInputPresenter whenSubmitDo: [ :busName |
		context followBus: (self application busNamed: busName).
		busesList filterInputPresenter clearContent.
		busesList items: self application buses.
		busesList selectItems: context buses copy ].
	^ busesList
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

{ #category : #executing }
MiEditBusCommand >> execute [

	
]

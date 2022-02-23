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

{ #category : #converting }
MiEditBusCommand >> asSpecCommand [

	| specCommand |
	specCommand := super asSpecCommand
		               name: 'Buses';
		               description: self help;
		               yourself.

	specCommand buildPresenterBlock: [ :cmd | 
		SpToolbarPopoverButtonPresenter new
			label: specCommand decoratedCommand label;
			help: specCommand decoratedCommand help;
			icon: specCommand icon;
			content: [ self busesList ];
			yourself ].

	^ specCommand
]

{ #category : #converting }
MiEditBusCommand >> busesList [

	| busesList |
	busesList := SpFilteringSelectableListPresenter new.
	busesList layout: (SpBoxLayout newTopToBottom
			 add: SpFilteringSelectableListPresenter defaultLayout
			 withConstraints: [ :c | 
				 c
					 height: 120;
					 width: 120 ];
			 yourself).
	busesList display: [ :bus | bus name ].
	busesList items: self application buses.
	busesList selectItems: context buses copy.

	busesList
		onActivation: [ :bus | bus ifNotNil: [ context followBus: bus ] ];
		onDeactivation: [ :bus | bus ifNotNil: [ context unfollowBus: bus ] ].

	"Do not filter bus use text input for bus creation"
	busesList filterInputPresenter placeholder: '+ New bus'.
	busesList itemFilter: [ :each :pattern | 
		true "We do not want to filter anything" ].
	busesList filterInputPresenter whenSubmitDo: [ 
		context followBus:
			(self application busNamed: busesList filterInputPresenter text).
		busesList filterInputPresenter clearContent.
		busesList items: self application buses.
		busesList selectItems: context buses copy  ].
	^ busesList
]

{ #category : #testing }
MiEditBusCommand >> canBeExecuted [

	^ self context canEditBuses
]

{ #category : #executing }
MiEditBusCommand >> execute [

	
]

{ #category : #converting }
MiEditBusCommand >> help [

	^ String streamContents: [ :s | 
		  self context buses do: [ :bus | 
			  s
				  << '- ';
				  << bus name;
				  cr ].
		  s << 'Click to edit' ]
]

{ #category : #converting }
MiEditBusCommand >> label [

	^ self context buses ifEmpty: [ 'No bus' ] ifNotEmpty: [ :buses | 
		  buses size = 1
			  ifTrue: [ 'Bus: ' , buses anyOne name ]
			  ifFalse: [ buses size asString , ' buses' ] ]
]

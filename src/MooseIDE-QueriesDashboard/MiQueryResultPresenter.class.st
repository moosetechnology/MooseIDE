Class {
	#name : 'MiQueryResultPresenter',
	#superclass : 'MiPresenter',
	#instVars : [
		'queryResult',
		'menu',
		'inspectButton',
		'propagateButton',
		'descriptionButton'
	],
	#category : 'MooseIDE-QueriesDashboard-Browser',
	#package : 'MooseIDE-QueriesDashboard',
	#tag : 'Browser'
}

{ #category : 'initialization' }
MiQueryResultPresenter >> buildButtons [

	| buttons comp |
	menu canvas color: Color transparent.
	descriptionButton canvas color: Color transparent.
	descriptionButton canvas add: (RSBitmap new
			 form: (self iconNamed: #comments);
			 model: 'Description';
			 when: RSMouseClick do: [ self displayDescription ] for: self;
			 @ self popupInteraction;
			 yourself).

	inspectButton := RSBitmap new
		                 form: (self iconNamed: #glamorousInspect);
		                 size: 16;
		                 model: 'Inspect result';
		                 yourself.

	inspectButton when: RSMouseClick do: [ MiInspectorBrowser inspect: queryResult result asMooseGroup ] for: self.

	propagateButton := RSBitmap new
		                   form: (self iconNamed: #mooseOutgoing);
		                   model: 'Propagate result';
		                   size: 16;
		                   yourself.
	propagateButton
		when: RSMouseClick
		do: [ self application miPropagate: queryResult result asMooseGroup on: self owner buses ]
		for: self.

	buttons := RSGroup withAll: {
			           inspectButton.
			           propagateButton }.

	queryResult browsers ifNotNil: [ :browsers |
			browsers do: [ :b |
					| newButton |
					newButton := RSBitmap new
						             form: (self iconNamed: #mooseFame);
						             size: 16;
						             model: 'Open with ' , b title;
						             when: RSMouseClick do: [ b openOn: queryResult result asMooseGroup ] for: self;
						             yourself.
					buttons add: newButton ] ].

	queryResult description ifNotNil: [ :d | descriptionButton show ].
	RSHorizontalLineLayout new
		alignMiddle;
		horizontalGap: 2;
		on: buttons.
	buttons @ self popupInteraction.
	comp := RSComposite new
		        addAll: buttons;
		        yourself.
	menu canvas add: comp.
	comp
		adjustToChildren;
		setAsFixed;
		translateTopLeftTo: 0 @ 0
]

{ #category : 'initialization' }
MiQueryResultPresenter >> createDescriptionFor: aString [

	^ aString asTextMorph
		  backgroundColor: (Color white alpha: 0.6);
		  borderColor: Color gray;
		  textColor: Color black;
		  borderWidth: 1;
		  margins: 2;
		  yourself
]

{ #category : 'initialization' }
MiQueryResultPresenter >> displayDescription [

	self newPopover
		relativeTo: descriptionButton;
		bePositionLeft;
		presenter: queryResult description asPresenter;
		popup
]

{ #category : 'initialization' }
MiQueryResultPresenter >> initializeLayout [

	| sep |
	sep := self newRoassal.
	sep canvas color: (Color fromHexString: '00000020').
	self layout: (SpBoxLayout newLeftToRight
			 vAlignCenter;
			 spacing: 2;
			 add: (self newImage
					  image: (self iconNamed: #mooseRemove);
					  yourself)
			 width: 16;
			 add: queryResult name asPresenter;
			 add: descriptionButton withConstraints: [ :cts | 
			 cts
				 height: 16;
				 width: 16 ];
			 add: sep width: 1;
			 add: menu withConstraints: [ :cts | 
			 cts
				 height: 16;
				 width: 150 ];
			 yourself)
]

{ #category : 'initialization' }
MiQueryResultPresenter >> initializePresenters [

	menu := self newRoassal.
	descriptionButton := self newRoassal
		                     hide;
		                     yourself.
	self addStyle: 'itemList'.
	self buildButtons.
	self initializeLayout
]

{ #category : 'initialization' }
MiQueryResultPresenter >> popupInteraction [

	^ RSMorphicPopupInteraction new
		  morphBuilder: [ :model | self createDescriptionFor: model ];
		  yourself
]

{ #category : 'initialization' }
MiQueryResultPresenter >> setModelBeforeInitialization: aQueryResult [

	queryResult := aQueryResult
]

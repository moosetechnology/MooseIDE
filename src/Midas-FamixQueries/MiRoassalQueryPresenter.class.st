Class {
	#name : #MiRoassalQueryPresenter,
	#superclass : #SpRoassalPresenter,
	#instVars : [
		'hasInteractions',
		'queries',
		'selectedQuery',
		'browser'
	],
	#category : #'Midas-FamixQueries-Widgets'
}

{ #category : #'boxes configuration' }
MiRoassalQueryPresenter >> adaptName: aString [
	^ Character cr
		join:
			(aString substrings
				collect: [ :s | (s withoutPrefix: 'numberOf') truncateWithElipsisTo: 15 ])
]

{ #category : #'roassal script' }
MiRoassalQueryPresenter >> adaptToBrowser: aBrowser [
	browser := aBrowser.
	selectedQuery := aBrowser selectedQuery.
	self script: [ :canvas | self roassalScriptOn: canvas ]
]

{ #category : #'boxes configuration' }
MiRoassalQueryPresenter >> boxDraggedAction: box [
	| potentialParents |
	owner selectQuery: box model.
	potentialParents := box canvas shapes
		select: [ :shape | 
			(shape isKindOf: RSBox)
				and: [ shape ~= box
						and: [ shape encompassingRectangle intersects: box encompassingRectangle ] ] ].
	potentialParents size == 1
		ifTrue: [ owner
				openCombinationPresenterFor: potentialParents first model
				and: box model ].
	self refresh
]

{ #category : #'boxes configuration' }
MiRoassalQueryPresenter >> boxInteractions: box [
	hasInteractions
		ifFalse: [ ^ self ].
	box @ RSDraggable.
	box
		when: RSMouseClick
			do: [ :event | self boxSelectionAction: event shape ];
		when: RSMouseDoubleClick
			do: [ :event | browser openQueryCreationPresenter ];
		when: RSMouseDragEnd
			do: [ :event | self boxDraggedAction: event shape ]
]

{ #category : #'boxes configuration' }
MiRoassalQueryPresenter >> boxLabel [
	| label |
	label := RSLabeled new text: [ :model | self adaptName: model name ].
	label location
		inner;
		center;
		middle.
	^ label
]

{ #category : #'boxes configuration' }
MiRoassalQueryPresenter >> boxPopup [
	| label |
	label := RSPopup new
		text: [ :model | 
			String
				streamContents: [ :s | 
					| firstWord complement |
					firstWord := model name substrings first.
					s
						<< firstWord;
						cr.
					complement := model name withoutPrefix: firstWord.
					complement
						ifNotEmpty: [ s
								<< complement;
								cr ].
					s << model result details ] ].
	^ label
]

{ #category : #'boxes configuration' }
MiRoassalQueryPresenter >> boxSelectionAction: box [
	selectedQuery := box model.
	browser selectQuery: selectedQuery.
	self refresh
]

{ #category : #'boxes configuration' }
MiRoassalQueryPresenter >> boxSize [
	^ 150
]

{ #category : #'boxes configuration' }
MiRoassalQueryPresenter >> buildBoxFor: aQuery [
	| box |
	box := RSBox new
		size: self boxSize;
		model: aQuery;
		color: aQuery class color;
		addInteraction: self boxLabel;
		addInteraction: self boxPopup;
		yourself.
	self boxInteractions: box.
	self decorateSelectedBox: box.
	^ box
]

{ #category : #'roassal script' }
MiRoassalQueryPresenter >> buildMenuOn: boxes [
	boxes
		do: [ :box | 
			box
				when: RSMouseRightClick
				do: [ :evt | 
					| menu |
					menu := (MiQueryMenuBuilder on: browser) newMenu
						buildWithSpecAsPopup.
					menu popUpInWorld ] ]
]

{ #category : #'roassal script' }
MiRoassalQueryPresenter >> buildTreeOn: canvas for: boxes [
	(RSEdgeBuilder new: (RSArrowedLine new color: self theme textColor))
		canvas: canvas;
		attachPoint: RSBorderAttachPoint new;
		shapes: boxes;
		connectToAll: #children.
	RSDominanceTreeLayout on: canvas nodes
]

{ #category : #'roassal script' }
MiRoassalQueryPresenter >> createBoxes [
	| boxes |
	boxes := queries
		collect: [ :query | self buildBoxFor: query ]
		as: RSGroup.
	hasInteractions
		ifTrue: [ self buildMenuOn: boxes ].
	^ boxes
]

{ #category : #'boxes configuration' }
MiRoassalQueryPresenter >> decorateSelectedBox: box [
	box model == selectedQuery
		ifFalse: [ ^ self ].
	box border: (RSBorder new width: 4).
	box borderColor: self theme textColor .

	"Does not work because the label is built (then known from the shape) only when the canvas is built."
	box properties at: #RSLabeled ifPresent: [ :label | label bold ]
]

{ #category : #initialization }
MiRoassalQueryPresenter >> initialize [
	super initialize.
	self withInteractions
]

{ #category : #'roassal script' }
MiRoassalQueryPresenter >> legendOn: canvas [
	| legend |
	queries size == 1
		ifTrue: [ ^ self ].
	legend := RSLegend new.
	legend container: canvas.
	((queries collectAsSet: [ :query | query class ])
		copyWithout: FQRootQuery)
		do:
			[ :queryClass | legend text: queryClass label withCircleColor: queryClass color ].
	legend
		leyendDo: [ :l | 
			(l nodes first children detect: [ :shape | shape isKindOf: RSLabel ])
				color: self theme textColor.
			l
				withBorder;
				color: self theme backgroundColor;
				padding: 20;
				scaleBy: 0.7 ].
	legend onDemand: 'Legend'.
	legend build
]

{ #category : #interactions }
MiRoassalQueryPresenter >> noInteractions [
	hasInteractions := false
]

{ #category : #'roassal script' }
MiRoassalQueryPresenter >> roassalScriptOn: canvas [
	| boxes |
	canvas color: self theme backgroundColor.
	boxes := self createBoxes.
	canvas addAll: boxes.
	self buildTreeOn: canvas for: boxes.
	self legendOn: canvas.
	canvas @ RSCanvasController new noLegend.
	^ canvas
]

{ #category : #update }
MiRoassalQueryPresenter >> selectItem: aQuery [
	selectedQuery := aQuery.
	self refresh
]

{ #category : #accessing }
MiRoassalQueryPresenter >> selectedItem [
	^ selectedQuery
]

{ #category : #'accessing model' }
MiRoassalQueryPresenter >> setModelBeforeInitialization: aQueriesCollection [
	queries := aQueriesCollection asOrderedCollection
]

{ #category : #update }
MiRoassalQueryPresenter >> updateWithQueries: aQueriesCollection [
	queries := aQueriesCollection asOrderedCollection.
	self selectItem: aQueriesCollection last
]

{ #category : #interactions }
MiRoassalQueryPresenter >> withInteractions [
	hasInteractions := true
]

Class {
	#name : #MiButterflyMapModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'currentEntity',
		'childrenBlock',
		'childrenQuery',
		'leftEntitiesQuery',
		'leftEntitiesBlock',
		'rightEntitiesQuery',
		'rightEntitiesBlock',
		'settings',
		'defaultChildrenQuery',
		'defaultLeftEntitiesQuery',
		'defaultRightEntitiesQuery'
	],
	#category : #'MooseIDE-ButterflyMap-Model'
}

{ #category : #accessing }
MiButterflyMapModel >> allPossibleQueries [

	^ (self browser itemsFor: FQAbstractQuery) as: OrderedCollection
]

{ #category : #accessing }
MiButterflyMapModel >> browser [

	^ browser
]

{ #category : #accessing }
MiButterflyMapModel >> browser: anObject [

	browser := anObject.
	self initializeSettings
]

{ #category : #accessing }
MiButterflyMapModel >> childrenBlock [

	^ childrenBlock
]

{ #category : #accessing }
MiButterflyMapModel >> childrenBlock: anObject [

	childrenBlock := anObject
]

{ #category : #accessing }
MiButterflyMapModel >> childrenFor: anEntity [

	^ self getChildrenQuery runOn: anEntity asMooseGroup
]

{ #category : #accessing }
MiButterflyMapModel >> childrenQuery [

	^ #childrenQuery
]

{ #category : #accessing }
MiButterflyMapModel >> currentEntity [

	^ currentEntity
]

{ #category : #accessing }
MiButterflyMapModel >> currentEntity: anObject [

	currentEntity := anObject.
	browser run
]

{ #category : #accessing }
MiButterflyMapModel >> defaultChildrenQuery [

	^ defaultChildrenQuery ifNil: [ 
		  defaultChildrenQuery := FQCollectScriptQuery new script: [ :each | 
			                          each children ] ]
]

{ #category : #accessing }
MiButterflyMapModel >> defaultLeftEntitiesQuery [

	^ defaultLeftEntitiesQuery ifNil: [ 
		  defaultLeftEntitiesQuery := FQCollectScriptQuery script: [ :entity | 
			                              entity allClients ] ]
]

{ #category : #accessing }
MiButterflyMapModel >> defaultRightEntitiesQuery [

	^ defaultRightEntitiesQuery ifNil: [ 
		  defaultRightEntitiesQuery := FQCollectScriptQuery script: [ 
			                               :entity | entity allProviders ] ]
]

{ #category : #accessing }
MiButterflyMapModel >> entities [
	"should probably return all entities displayed and not only the central one"
	^self currentEntity
		ifNil: [ #() ]
		ifNotNil: [ :entity | { entity } ]
]

{ #category : #accessing }
MiButterflyMapModel >> getChildrenQuery [

	^ settings getItemValue: self childrenQuery
]

{ #category : #actions }
MiButterflyMapModel >> getLeftEntitiesQuery [

	^ settings getItemValue: self leftEntitiesQuery
]

{ #category : #actions }
MiButterflyMapModel >> getRightEntitiesQuery [

	^ settings getItemValue: self rightEntitiesQuery
]

{ #category : #accessing }
MiButterflyMapModel >> initializeSettings [

	settings := MiSettingsPresenter new
		            ownerTool: self;
		            addItem: self itemChildrenQuery
		            named: self childrenQuery;
		            addItem: self itemLeftEntitiesQuery
		            named: self leftEntitiesQuery;
		            addItem: self itemRightEntitiesQuery
		            named: self rightEntitiesQuery;
		            yourself
]

{ #category : #accessing }
MiButterflyMapModel >> itemChildrenQuery [

	^ MiAbstractSettingItem droplistSetting
		  possibleValues:
			  { self defaultChildrenQuery } , self allPossibleQueries;
		  setValue: self defaultChildrenQuery;
		  label: 'Node children query';
		  help:
			  'The query computing children for each node in order to get inner elements.';
		  yourself
]

{ #category : #accessing }
MiButterflyMapModel >> itemLeftEntitiesQuery [

	^ MiAbstractSettingItem droplistSetting
		  possibleValues:
			  { self defaultLeftEntitiesQuery} , self allPossibleQueries;
		  setValue: self defaultLeftEntitiesQuery;
		  label: 'Left entities query';
		  help:
			  'The query computing left entities from the central entity.';
		  yourself
]

{ #category : #accessing }
MiButterflyMapModel >> itemRightEntitiesQuery [

	^ MiAbstractSettingItem droplistSetting
		  possibleValues:
			  { self defaultRightEntitiesQuery } , self allPossibleQueries;
		  setValue: self defaultRightEntitiesQuery;
		  label: 'Right entities query';
		  help:
			  'The query computing right entities from the central entity.';
		  yourself
]

{ #category : #accessing }
MiButterflyMapModel >> leftEntitiesFor: anEntity [

	^ self getLeftEntitiesQuery runOn: anEntity asMooseGroup
]

{ #category : #accessing }
MiButterflyMapModel >> leftEntitiesQuery [

	^ #leftEntitiesQuery
]

{ #category : #actions }
MiButterflyMapModel >> openSettings [

	settings open
]

{ #category : #accessing }
MiButterflyMapModel >> rightEntitiesFor: anEntity [

	^ self getRightEntitiesQuery runOn: anEntity asMooseGroup
]

{ #category : #accessing }
MiButterflyMapModel >> rightEntitiesQuery [

	^ #rightEntitiesQuery
]

{ #category : #accessing }
MiButterflyMapModel >> settings [

	^ settings
]

{ #category : #accessing }
MiButterflyMapModel >> settingsChanged: aBoolean [

	aBoolean ifTrue: [ browser run ]
]

{ #category : #accessing }
MiButterflyMapModel >> toolName [

	^ self browser title
]

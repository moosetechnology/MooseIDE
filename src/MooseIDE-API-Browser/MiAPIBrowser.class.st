"
A visualization showing API dependencies between 2 ""subsystems""
Currently very specialized for Corese-core and Corese-command
(see `P16APIMapModel >> #allInvocations`)

Use:
  Launch it and propagate a full corese model to it
"
Class {
	#name : 'MiAPIBrowser',
	#superclass : 'MiAbstractVisualizationBrowser',
	#category : 'MooseIDE-API-Browser-browser',
	#package : 'MooseIDE-API-Browser',
	#tag : 'browser'
}

{ #category : 'accessing' }
MiAPIBrowser class >> mapClass [

	^ MiAPIVisualization 
]

{ #category : 'instance creation' }
MiAPIBrowser class >> newModel [

	^ MiAPIMapModel new
]

{ #category : 'instance creation' }
MiAPIBrowser class >> open [

	<script>
	^ super open
]

{ #category : 'specs' }
MiAPIBrowser class >> title [

	^ 'API explorer'
]

{ #category : 'interactions' }
MiAPIBrowser >> addToSelection: entities [
	"Add to currently selected shapes all shapes for entities"

	| shapesToHighlight shapesHighlighted |

	shapesHighlighted := self canvas selectedShapes ifNil: [ #(  ) ].
	shapesToHighlight := self shapesFromModels: entities.

	self canvas setSelectedShapes: shapesToHighlight , shapesHighlighted
]

{ #category : 'testing' }
MiAPIBrowser >> canFollowEntity: anObject [

	^anObject isMooseObject
]

{ #category : 'accessing' }
MiAPIBrowser >> canvas [

	^mainPresenter canvas
]

{ #category : 'accessing' }
MiAPIBrowser >> defaultNodeStyle [

	^MiArchitecturalMapStyle new
]

{ #category : 'actions' }
MiAPIBrowser >> followEntity: anEntity [

	| mooseModel |
	mooseModel := self getMooseModel: anEntity.
	super followEntity: mooseModel.
	self specModel mooseModel: mooseModel
]

{ #category : 'accessing' }
MiAPIBrowser >> getMooseModel: aMooseObject [

	aMooseObject isMooseModel ifTrue: [ ^aMooseObject ].
	aMooseObject isCollection  ifTrue: [ ^aMooseObject anyOne mooseModel ].
	^aMooseObject mooseModel
]

{ #category : 'testing' }
MiAPIBrowser >> hasSettings [

	^true
]

{ #category : 'initialization' }
MiAPIBrowser >> initializeLayout [

	self layout: (SpScrollableLayout with: mainPresenter)
]

{ #category : 'initialization' }
MiAPIBrowser >> initializePresenters [

	mainPresenter := self class mapClass owner: self.
	specModel browser: self.
	self initializeLayout
]

{ #category : 'accessing' }
MiAPIBrowser >> linkShapesFromModels: associations [

	| linkShapes |
	linkShapes := self canvas shapes select: #isLine.

	^ associations collect: [ :assoc |
			  | shapeFrom shapeTo |
			  shapeFrom := self canvas shapeFromModel:
				               (assoc key cacheAt: #p16APIHNode).
			  shapeTo := self canvas shapeFromModel:
				             (assoc value cacheAt: #p16APIHNode).

			  linkShapes detect: [ :link |
				  link from = shapeFrom and: [ link to = shapeTo ] ] ]
]

{ #category : 'accessing' }
MiAPIBrowser >> miSelectedItem [

	mainPresenter ifNil: [ ^#() ].

	^super miSelectedItem
]

{ #category : 'accessing' }
MiAPIBrowser >> nodeShapesFromModels: famixEntities [

	^ self canvas shapesFromModels:
		  (famixEntities collect: [ :fmx | fmx cacheAt: #p16APIHNode ])
]

{ #category : 'interactions' }
MiAPIBrowser >> removeFromSelection: entities [
	"Remove from currently selected shapes those representing #entities"

	| shapesToUnhighlight shapesHighlighted |

	shapesHighlighted := self canvas selectedShapes ifNil: [ #() ].
	shapesToUnhighlight := self shapesFromModels: entities.

	self canvas setSelectedShapes: (shapesHighlighted \ shapesToUnhighlight)
]

{ #category : 'accessing' }
MiAPIBrowser >> shapesFromModels: famixEntities [
	"note: both lists or sets, but we cannot use concatenation on sets :-(
	   so we make an OrderedCollection of it"

	^(self nodeShapesFromModels: (famixEntities reject: [ :fmx | fmx isAssociation ])) ,
	(self linkShapesFromModels: (famixEntities select: [ :fmx | fmx isAssociation ]))
	
]

{ #category : 'actions' }
MiAPIBrowser >> updateTags [
	| styler |
	styler := self defaultNodeStyle.
	mainPresenter currentCanvas shapes do: [ :sh |
		sh isLine ifFalse: [
			sh resetChildren.
			styler buildCompositeEmptyNodeIn: sh
		]
	]
]

Class {
	#name : #MiModelDashboardModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'mooseModel',
		'reportDOM',
		'context'
	],
	#category : #'MooseIDE-Core-ModelDashboard'
}

{ #category : #document }
MiModelDashboardModel >> bulletList: aCollection [

	| block |
	block := MicUnorderedListBlock new
		parent: self currentBlock.

	aCollection do: [ :item || itemBlock |
		itemBlock := MicListItemBlock new
			parent: block.

		item parent: itemBlock.
		itemBlock addChild: item
	].

	block closeMe.
	^block

]

{ #category : #accessing }
MiModelDashboardModel >> currentBlock [

	^context top
]

{ #category : #document }
MiModelDashboardModel >> document [
		
	self title: ('Dashboard : '  , mooseModel name).

	self packageSection.
	"self classSection.
	self methodSection."

]

{ #category : #document }
MiModelDashboardModel >> endSection [

	context pop
]

{ #category : #accessing }
MiModelDashboardModel >> entities [
	^mooseModel
]

{ #category : #accessing }
MiModelDashboardModel >> followEntity: aMooseModel [

	mooseModel := aMooseModel.
	self updateReport
]

{ #category : #document }
MiModelDashboardModel >> headerBlock: level header: aString [

	| block |
	block := MicHeaderBlock new
		level: level;
		parent: self currentBlock.
	self textBlock: aString in: block.

	^ block
]

{ #category : #accessing }
MiModelDashboardModel >> miSelectedItem [

	^#()
]

{ #category : #document }
MiModelDashboardModel >> numericValue: text value: number [

	^self textBlock: (text , ': ' , number asString) in: nil
		
]

{ #category : #document }
MiModelDashboardModel >> packageSection [
	| number |

	self subtitle: 'Packages'.

	number := mooseModel allModelPackages size.
	self bulletList: {
		self numericValue: 'Number of Packages' value: number.
		 self numericValue: 'Average number of classes' value: (((mooseModel allModelClasses size) / number) round: 1) asFloat.
	}.

]

{ #category : #accessing }
MiModelDashboardModel >> reportDOM [

	^ reportDOM
]

{ #category : #settings }
MiModelDashboardModel >> settings [

]

{ #category : #document }
MiModelDashboardModel >> subtitle: aString [

	^self headerBlock: 2 header: aString.

]

{ #category : #document }
MiModelDashboardModel >> textBlock: aString in: parentBlock [

	| block |
	block := MicTextBlock new
		substring: aString;
		parent: parentBlock.
	parentBlock ifNotNil: [parentBlock addChild: block].

	^block
]

{ #category : #document }
MiModelDashboardModel >> title: aString [

	^self headerBlock: 1 header: aString.

]

{ #category : #running }
MiModelDashboardModel >> updateReport [

	context := Stack new.
	context push: MicRootBlock new.

	self document.

	reportDOM := context top.
	1halt.
	browser updateReport: (MicRichTextComposer new asRichText: reportDOM).
]

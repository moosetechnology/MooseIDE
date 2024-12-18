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

{ #category : #microdown }
MiModelDashboardModel >> bulletList: aCollection [

	| block |
	block := MicUnorderedListBlock new.
		
	context push: block.

	aCollection do: [ :item || itemBlock |
		itemBlock := MicListItemBlock new
			parent: block.

		self ensure: itemBlock parentOf: item
	].

	self endSection.

	^block

]

{ #category : #accessing }
MiModelDashboardModel >> currentBlock [

	^context top
]

{ #category : #document }
MiModelDashboardModel >> document [
		
	self title: ('Dashboard : '  , mooseModel name).

	self sectionPackages.
	self sectionClasses.
	self sectionMethods.

]

{ #category : #document }
MiModelDashboardModel >> endSection [

	context pop
]

{ #category : #microdown }
MiModelDashboardModel >> ensure: parentBlock parentOf: childBlock [

	childBlock parent: parentBlock.
	(parentBlock children includes: childBlock)
		ifFalse: [ parentBlock addChild: childBlock ]
]

{ #category : #accessing }
MiModelDashboardModel >> entities [
	^mooseModel
]

{ #category : #document }
MiModelDashboardModel >> floatAsString: aFloat [

	^(aFloat asFloat round: 1) asString

]

{ #category : #accessing }
MiModelDashboardModel >> followEntity: aMooseModel [

	mooseModel := aMooseModel.
	self updateReport
]

{ #category : #document }
MiModelDashboardModel >> fullyQualifiedName: anEntity [

	^anEntity mooseName copyReplaceAll: '::' with: '.' 

]

{ #category : #microdown }
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

{ #category : #microdown }
MiModelDashboardModel >> numericValue: text value: number [

	^self textBlock: (text , ': ' , number asString) in: nil
		
]

{ #category : #microdown }
MiModelDashboardModel >> paragraph: aCollection [

	| block |
	block := MicParagraphBlock new
		parent: self currentBlock.
		
	context push: block.

	aCollection do: [ :each |
		self ensure: block parentOf: each
	].

	self endSection.

	^block

]

{ #category : #accessing }
MiModelDashboardModel >> reportDOM [

	^ reportDOM
]

{ #category : #document }
MiModelDashboardModel >> sectionClasses [

	self subtitle: 'Classes'.

	self sectionClassesMemberStats: mooseModel allModelClasses.

	self subSectionSpecialClasses: [ :c | c numberOfMethods > 200 ] description: 'Large classes (> 200 methods)'.
	self subSectionSpecialClasses: [ :c | c numberOfLinesOfCode > 2000 ] description: 'Long classes (> 2000 LOC)'

]

{ #category : #document }
MiModelDashboardModel >> sectionClassesMemberStats: classes [

	self stats: (classes collect: [ :c | c numberOfAttributes ]) description: 'attributes'.
	self stats: (classes collect: [ :c | c numberOfMethods ]) description: 'methods'
]

{ #category : #document }
MiModelDashboardModel >> sectionMethods [

	self subtitle: 'Methods'.

	self sectionMethodsStats: mooseModel allModelMethods.

	self subSectionSpecialMethods: [ :m | m numberOfLinesOfCode > 200 ] description: 'Long methods (> 200 LOC)'.
	self subSectionSpecialMethods: [ :m | m cyclomaticComplexity > 50 ] description: 'Complex methods (cyclomatic complexity > 50)'

]

{ #category : #document }
MiModelDashboardModel >> sectionMethodsStats: methods [

	self stats: (methods collect: [ :c | c numberOfParameters ]) description: 'parameters'.
	self stats: (methods collect: [ :c | c numberOfLinesOfCode ]) description: 'lines of code'.
	self stats: (methods collect: [ :c | c cyclomaticComplexity ]) description: 'cyclomatic complexity'

]

{ #category : #document }
MiModelDashboardModel >> sectionPackages [
	| number allClasses |

	self subtitle: 'Packages'.

	number := mooseModel allModelPackages size.
	allClasses := mooseModel allModelClasses asOrderedCollection.

	self paragraph: {
		self bulletList: {
			self numericValue: 'Number of Packages' value: number.
			self numericValue: 'Mean number of classes' value: (self floatAsString: (allClasses size / number)).
			self numericValue: 'Total number of classes' value: allClasses size.
			self numericValue: 'Total number of lines of code' value: (allClasses sum: #numberOfLinesOfCode).
		}
	}.

]

{ #category : #settings }
MiModelDashboardModel >> settings [

]

{ #category : #document }
MiModelDashboardModel >> stats: numberCollection description: aString [

	| collection |
	collection := numberCollection asOrderedCollection.

	self paragraph: {
		self textBlock: (aString capitalized , ':') in: nil.
		self bulletList: {
			self numericValue: ('Mean number of ' , aString) value: (self floatAsString: collection average) .
			self numericValue: ('Median number of ' , aString) value: collection median .
			self numericValue: ('Max number of ' , aString) value: collection max
		}
	}

]

{ #category : #document }
MiModelDashboardModel >> subSectionSpecialClasses: selectionBlock description: aString [

	| largeClasses |
	self subsubtitle: aString.

	largeClasses := (mooseModel allModelClasses select: selectionBlock)
		sorted: [:a :b | a mooseName < b mooseName].

	self paragraph: {
		self numericValue: 'Number' value: largeClasses size.
		self bulletList: (largeClasses collect: [:c | self textBlock: (self fullyQualifiedName: c) in: nil] )
	}.

	self sectionClassesMemberStats: largeClasses 

]

{ #category : #document }
MiModelDashboardModel >> subSectionSpecialMethods: selectionBlock description: aString [

	| methods |
	self subsubtitle: aString.

	methods := (mooseModel allModelMethods select: selectionBlock)
		sorted: [:a :b | a mooseName < b mooseName].

	self paragraph: {
		self numericValue: 'Number' value: methods size.
		self bulletList: (methods collect: [:c | self textBlock: (self fullyQualifiedName: c) in: nil] )
	}.

	self sectionMethodsStats: methods 

]

{ #category : #microdown }
MiModelDashboardModel >> subsubtitle: aString [

	^self headerBlock: 3 header: aString.

]

{ #category : #microdown }
MiModelDashboardModel >> subtitle: aString [

	^self headerBlock: 2 header: aString.

]

{ #category : #microdown }
MiModelDashboardModel >> textBlock: aString in: parentBlock [

	| block |
	block := MicTextBlock new
		substring: aString;
		parent: parentBlock.
	parentBlock ifNotNil: [parentBlock addChild: block].

	^block
]

{ #category : #microdown }
MiModelDashboardModel >> title: aString [

	^self headerBlock: 1 header: aString.

]

{ #category : #running }
MiModelDashboardModel >> updateReport [

	context := Stack new.
	context push: MicRootBlock new.

	self document.

	reportDOM := context top.

	browser updateReport: (MicTextualMicrodownExporter new visit: reportDOM).
]

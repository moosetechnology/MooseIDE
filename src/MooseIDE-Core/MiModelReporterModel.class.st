"
The spec model for the MiModelReporter

Responsible for actually generating the report
"
Class {
	#name : #MiModelReporterModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'mooseModel',
		'reportDOM',
		'context'
	],
	#category : #'MooseIDE-Core-Reporter'
}

{ #category : #microdown }
MiModelReporterModel >> bulletList: aCollection [

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
MiModelReporterModel >> currentBlock [

	^context top
]

{ #category : #document }
MiModelReporterModel >> document [
		
	self title: ('Dashboard : '  , mooseModel name).

	self sectionPackages.
	self sectionClasses.
	self sectionMethods.

]

{ #category : #document }
MiModelReporterModel >> endSection [

	context pop
]

{ #category : #microdown }
MiModelReporterModel >> ensure: parentBlock parentOf: childBlock [

	childBlock parent: parentBlock.
	(parentBlock children includes: childBlock)
		ifFalse: [ parentBlock addChild: childBlock ]
]

{ #category : #accessing }
MiModelReporterModel >> entities [
	^mooseModel
]

{ #category : #document }
MiModelReporterModel >> floatAsString: aFloat [

	^(aFloat asFloat round: 1) asString

]

{ #category : #accessing }
MiModelReporterModel >> followEntity: aMooseModel [

	mooseModel := aMooseModel.
	self updateReport
]

{ #category : #document }
MiModelReporterModel >> fullyQualifiedName: anEntity [

	^anEntity mooseName copyReplaceAll: '::' with: '.' 

]

{ #category : #microdown }
MiModelReporterModel >> headerBlock: level header: aString [

	| block |
	block := MicHeaderBlock new
		level: level;
		parent: self currentBlock.
	self textBlock: aString in: block.

	^ block
]

{ #category : #accessing }
MiModelReporterModel >> miSelectedItem [

	^#()
]

{ #category : #microdown }
MiModelReporterModel >> numericValue: text value: number [

	^self textBlock: (text , ': ' , number asString) in: nil
		
]

{ #category : #microdown }
MiModelReporterModel >> paragraph: aCollection [

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
MiModelReporterModel >> reportDOM [

	^ reportDOM
]

{ #category : #document }
MiModelReporterModel >> sectionClasses [

	self subtitle: 'Classes'.

	self sectionClassesMemberStats: mooseModel allModelClasses.

	self subSectionSpecialClasses: [ :c | c numberOfMethods > 200 ] description: 'Large classes (> 200 methods)'.
	self subSectionSpecialClasses: [ :c | c numberOfLinesOfCode > 2000 ] description: 'Long classes (> 2000 LOC)'

]

{ #category : #document }
MiModelReporterModel >> sectionClassesMemberStats: classes [

	self stats: (classes collect: [ :c | c numberOfAttributes ]) description: 'attributes'.
	self stats: (classes collect: [ :c | c numberOfMethods ]) description: 'methods'
]

{ #category : #document }
MiModelReporterModel >> sectionMethods [

	self subtitle: 'Methods'.

	self sectionMethodsStats: mooseModel allModelMethods.

	self subSectionSpecialMethods: [ :m | m numberOfLinesOfCode > 200 ] description: 'Long methods (> 200 LOC)'.
	self subSectionSpecialMethods: [ :m | m cyclomaticComplexity > 50 ] description: 'Complex methods (cyclomatic complexity > 50)'

]

{ #category : #document }
MiModelReporterModel >> sectionMethodsStats: methods [

	self stats: (methods collect: [ :c | c numberOfParameters ]) description: 'parameters'.
	self stats: (methods collect: [ :c | c numberOfLinesOfCode ]) description: 'lines of code'.
	self stats: (methods collect: [ :c | c cyclomaticComplexity ]) description: 'cyclomatic complexity'

]

{ #category : #document }
MiModelReporterModel >> sectionPackages [
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
MiModelReporterModel >> settings [

]

{ #category : #document }
MiModelReporterModel >> stats: numberCollection description: aString [

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
MiModelReporterModel >> subSectionSpecialClasses: selectionBlock description: aString [

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
MiModelReporterModel >> subSectionSpecialMethods: selectionBlock description: aString [

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
MiModelReporterModel >> subsubtitle: aString [

	^self headerBlock: 3 header: aString.

]

{ #category : #microdown }
MiModelReporterModel >> subtitle: aString [

	^self headerBlock: 2 header: aString.

]

{ #category : #microdown }
MiModelReporterModel >> textBlock: aString in: parentBlock [

	| block |
	block := MicTextBlock new
		substring: aString;
		parent: parentBlock.
	parentBlock ifNotNil: [parentBlock addChild: block].

	^block
]

{ #category : #microdown }
MiModelReporterModel >> title: aString [

	^self headerBlock: 1 header: aString.

]

{ #category : #running }
MiModelReporterModel >> updateReport [

	context := Stack new.
	context push: MicRootBlock new.

	self document.

	reportDOM := context top.

	browser updateReport: (MicTextualMicrodownExporter new visit: reportDOM).
]

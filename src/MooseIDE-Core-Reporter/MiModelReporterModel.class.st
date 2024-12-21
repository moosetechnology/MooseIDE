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
		'context',
		'settings'
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

{ #category : #settings }
MiModelReporterModel >> complexMethodLimit [

	^ settings getItemValue: #complexMethodSetting
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

{ #category : #'as yet unclassified' }
MiModelReporterModel >> exportReportToHTML: microdownText [

	(mooseModel name , '-report.html') asFileReference writeStreamDo: [ :stream |
		stream nextPutAll: (MicHTMLVisitor asHTMLString: microdownText)
	]
]

{ #category : #'as yet unclassified' }
MiModelReporterModel >> exportReportToPDF: microdownText [

	self inform: 'PDF export not implemented yet, sorry'
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

{ #category : #initialization }
MiModelReporterModel >> initializeSettings [ 

	settings := super initializeSettings.
	settings
		addItem: (MiTextSettingItem integerSetting
			setValue: 100 ;
			label: 'Large class' ;
			help: 'Above this number of methods, a class is considered large' ;
			yourself)
		named: #largeClassSetting ;

		addItem: (MiTextSettingItem integerSetting
			setValue: 1000 ;
			label: 'Long class' ;
			help: 'Above this number of Lines Of Code, a class is considered long' ;
			yourself)
		named: #longClassSetting ;

		addItem: (MiTextSettingItem integerSetting
			setValue: 100 ;
			label: 'Long method' ;
			help: 'Above this number of Lines Of Code, a method is considered long' ;
			yourself)
		named: #longMethodSetting;

		addItem: (MiTextSettingItem integerSetting
			setValue: 50 ;
			label: 'Complex method' ;
			help: 'Above this cyclomatic complexity, a method is considered complex' ;
		yourself)
		named: #complexMethodSetting.


]

{ #category : #settings }
MiModelReporterModel >> largeClassLimit [

	^ settings getItemValue: #largeClassSetting
]

{ #category : #settings }
MiModelReporterModel >> longClassLimit [

	^ settings getItemValue: #longClassSetting
]

{ #category : #settings }
MiModelReporterModel >> longMethodLimit [

	^ settings getItemValue: #longMethodSetting
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

	| limit |
	self subtitle: 'Classes'.

	self sectionClassesMemberStats: mooseModel allModelClasses.

	limit := self largeClassLimit.
	self
		subSectionSpecialClasses: [ :c | c numberOfMethods > limit ]
		description: 'Large classes (> ' , limit asString , ' methods)'.

	limit := self longClassLimit.
	self
		subSectionSpecialClasses: [ :c | c numberOfLinesOfCode > limit ]
		description: 'Long classes (> ', limit asString , ' LOC)'

]

{ #category : #document }
MiModelReporterModel >> sectionClassesMemberStats: classes [

	self stats: (classes collect: [ :c | c numberOfAttributes ]) description: 'attributes'.
	self stats: (classes collect: [ :c | c numberOfMethods ]) description: 'methods'
]

{ #category : #document }
MiModelReporterModel >> sectionMethods [

	| limit |
	self subtitle: 'Methods'.

	self sectionMethodsStats: mooseModel allModelMethods.

	limit := self longMethodLimit.
	self
		subSectionSpecialMethods: [ :m | m numberOfLinesOfCode > limit ]
		description: 'Long methods (> ', limit asString ,' LOC)'.

	limit := self complexMethodLimit.
	self
		subSectionSpecialMethods: [ :m | m cyclomaticComplexity > limit ]
		description: 'Complex methods (cyclomatic complexity > ', limit asString, ')'

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

	^settings
]

{ #category : #settings }
MiModelReporterModel >> settingsChanged: aBoolean [

	aBoolean ifTrue: [ self updateReport ]
]

{ #category : #document }
MiModelReporterModel >> stats: numberCollection description: aString [

	| collection |
	numberCollection ifEmpty: [ ^self ].

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

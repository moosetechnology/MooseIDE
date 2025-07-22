"
The spec model for the MiModelReporter

Responsible for actually generating the report
"
Class {
	#name : 'MiModelReporterModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'mooseModel',
		'settings',
		'report'
	],
	#category : 'MooseIDE-Reporter',
	#package : 'MooseIDE-Reporter'
}

{ #category : 'microdown' }
MiModelReporterModel >> bulletList: aCollection [

	aCollection do: [ :line |
		report
			<< '- ' ;
			<< line ;
			cr
	].
	report cr
]

{ #category : 'document' }
MiModelReporterModel >> classMembersStats: columns [

	self stats: columns compute: [ :c | c numberOfAttributes ] description: 'ATTRIBUTES'.
	self stats: columns compute: [ :c | c numberOfMethods ]    description: 'METHODS'
]

{ #category : 'settings' }
MiModelReporterModel >> complexMethodLimit [

	^ settings getItemValue: #complexMethodSetting
]

{ #category : 'document' }
MiModelReporterModel >> document [
		
	self title: ('Dashboard : '  , mooseModel name).

	self sectionPackages.
	self sectionClasses.
	self sectionMethods.

]

{ #category : 'accessing' }
MiModelReporterModel >> entities [
	^mooseModel
]

{ #category : 'api - export' }
MiModelReporterModel >> exportReportToHTML: microdownText [

	(mooseModel name , '-report.html') asFileReference writeStreamDo: [ :stream |
		stream nextPutAll: (MicHTMLVisitor asHTMLString: microdownText)
	]
]

{ #category : 'api - export' }
MiModelReporterModel >> exportReportToPDF: microdownText [

	self inform: 'PDF export not implemented yet, sorry'
]

{ #category : 'private - formatting' }
MiModelReporterModel >> floatAsString: aFloat [

	^(aFloat asFloat round: 1) asString

]

{ #category : 'accessing' }
MiModelReporterModel >> followEntity: aMooseModel [

	mooseModel := aMooseModel.
	self updateReport
]

{ #category : 'private - formatting' }
MiModelReporterModel >> formatCollection: collection value: valueBlock [

	^collection
		ifEmpty: [ 'n/a' ]
		ifNotEmpty: [ self floatAsString: (valueBlock value: collection) ]
]

{ #category : 'private - formatting' }
MiModelReporterModel >> fullyQualifiedName: anEntity [

	^anEntity mooseName copyReplaceAll: '::' with: '.' 

]

{ #category : 'microdown' }
MiModelReporterModel >> headerBlock: level header: aString [

	level timesRepeat: [ report << '#' ].
	report
		space ;
		<< aString ;
		cr ; cr
]

{ #category : 'initialization' }
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

{ #category : 'settings' }
MiModelReporterModel >> largeClassLimit [

	^ settings getItemValue: #largeClassSetting
]

{ #category : 'microdown' }
MiModelReporterModel >> line: aString [

	report
		<< aString ;
		cr

]

{ #category : 'settings' }
MiModelReporterModel >> longClassLimit [

	^ settings getItemValue: #longClassSetting
]

{ #category : 'settings' }
MiModelReporterModel >> longMethodLimit [

	^ settings getItemValue: #longMethodSetting
]

{ #category : 'document' }
MiModelReporterModel >> methodMembersStats: columns [

	self stats: columns compute: [ :m | m numberOfParameters ] description: 'PARAMETERS'.
	self stats: columns compute: [ :m | m numberOfLinesOfCode ]    description: 'LINES OF CODE'.
	self stats: columns compute: [ :m | m cyclomaticComplexity ]    description: 'CYCLOMATIC COMPLEXITY'
]

{ #category : 'accessing' }
MiModelReporterModel >> miSelectedItem [

	^#()
]

{ #category : 'private - formatting' }
MiModelReporterModel >> numericValue: text value: number [

	^text , ': ' , number asString
		
]

{ #category : 'accessing' }
MiModelReporterModel >> reportDOM [

	^ report
]

{ #category : 'document' }
MiModelReporterModel >> sectionClasses [

	| allClasses largeClasses longClasses |

	allClasses := OrderedCollection withAll: mooseModel allModelClasses.
	largeClasses := allClasses select: [ :c | c numberOfMethods > self largeClassLimit ].
	longClasses := allClasses select: [ :c | c numberOfLinesOfCode > self longClassLimit ].

	self subtitle: 'Classes'.

	"Stats table"
	self tableHeader: { '' . 'All' . 'Large' . 'Long' }.
	self statLine: { allClasses size asString . largeClasses size asString . longClasses size asString } description: 'number'.
	self classMembersStats: { allClasses . largeClasses . longClasses }.
	self line: ''.

	"Lists of entities"
	self
		subSectionSpecialList: largeClasses
		description: 'Large classes (> ' , self largeClassLimit asString , ' methods)'.
	self
		subSectionSpecialList: longClasses
		description: 'Long classes (> ' , self longClassLimit asString , ' LOC)'
]

{ #category : 'document' }
MiModelReporterModel >> sectionMethods [

	| allMethods longMethods complexMethods |

	allMethods := OrderedCollection withAll: mooseModel allModelMethods.
	longMethods := allMethods select: [ :c | c numberOfLinesOfCode > self longMethodLimit ].
	complexMethods := allMethods select: [ :c | c cyclomaticComplexity > self complexMethodLimit ].

	self subtitle: 'Methods'.

	"Stats table"
	self tableHeader: { '' . 'All' . 'Long' . 'Complex' }.
	self statLine: { allMethods size asString . longMethods size asString . complexMethods size asString } description: 'number'.
	self methodMembersStats: { allMethods . longMethods . complexMethods }.
	self line: ''.

	"Lists of entities"
	self
		subSectionSpecialList: longMethods
		description: 'Long methods (> ' , self longMethodLimit asString , ' LOC)'.
	self
		subSectionSpecialList: complexMethods
		description: 'Complex methods (cyclomatic complexity > ' , self complexMethodLimit asString , ')'
]

{ #category : 'document' }
MiModelReporterModel >> sectionMethodsStats: methods [

	self stats: (methods collect: [ :c | c numberOfParameters ]) description: 'parameters'.
	self stats: (methods collect: [ :c | c numberOfLinesOfCode ]) description: 'lines of code'.
	self stats: (methods collect: [ :c | c cyclomaticComplexity ]) description: 'cyclomatic complexity'

]

{ #category : 'document' }
MiModelReporterModel >> sectionPackages [
	| number allClasses |

	self subtitle: 'Packages'.

	number := mooseModel allModelPackages size.
	allClasses := mooseModel allModelClasses asOrderedCollection.

	self line:
		(self numericValue: 'Number of Packages' value: number).
	self line:
		(self numericValue: 'Mean number of classes' value: (self floatAsString: (allClasses size / number))).
	self line:
		(self numericValue: 'Total number of classes' value: allClasses size).
	self line:
		(self numericValue: 'Total number of lines of code' value: (allClasses sum: #numberOfLinesOfCode)).
	self line: ''

]

{ #category : 'settings' }
MiModelReporterModel >> settings [

	^settings
]

{ #category : 'settings' }
MiModelReporterModel >> settingsChanged: aBoolean [

	aBoolean ifTrue: [ self updateReport ]
]

{ #category : 'microdown' }
MiModelReporterModel >> statLine: columns	description: aString [

	self tableLine: { aString } , columns
]

{ #category : 'microdown' }
MiModelReporterModel >> stats: columns compute: valueBlock description: aString [
	"columns is a collection of collections of entities (eg. {allClasses, largeClasses, longClasses})
	 valueBlock takes one entity of these collections and compute a number form it (eg. numberOfAttributes)
	 From this, we display 3 lines: mean value, median value, max value for each column"

	| valuesCollection |
	valuesCollection := columns collect: [ :collection | collection collect: valueBlock ].

	self tableLine: { aString }.
	self
		statLine: (valuesCollection collect: [ :column | self formatCollection: column value: #average])
		description: '. mean'.
	self
		statLine: (valuesCollection collect: [ :column | self formatCollection: column value: #median])
		description: '. median'.
	self
		statLine: (valuesCollection collect: [ :column | self formatCollection: column value: #max])
		description: '. max'

]

{ #category : 'document' }
MiModelReporterModel >> subSectionSpecialList: collection description: aString [

	self subsubtitle: aString.

	self line: (self numericValue: 'Number' value: collection size).

	self bulletList: ((collection collect: [:c | self fullyQualifiedName: c ])
		sorted: [:a :b | a mooseName < b mooseName]).

]

{ #category : 'document' }
MiModelReporterModel >> subSectionSpecialMethods: selectionBlock description: aString [

	| methods |
	self subsubtitle: aString.

	methods := (mooseModel allModelMethods select: selectionBlock)
		sorted: [:a :b | a mooseName < b mooseName].

	self line: (self numericValue: 'Number' value: methods size).
	self bulletList: (methods collect: [:c | self fullyQualifiedName: c ] ).

	self sectionMethodsStats: methods 

]

{ #category : 'microdown' }
MiModelReporterModel >> subsubtitle: aString [

	^self headerBlock: 3 header: aString.

]

{ #category : 'microdown' }
MiModelReporterModel >> subtitle: aString [

	^self headerBlock: 2 header: aString.

]

{ #category : 'microdown' }
MiModelReporterModel >> tableHeader: aCollection [

	self tableLine: aCollection.
	report
		<< '|---|' ;
		cr
]

{ #category : 'microdown' }
MiModelReporterModel >> tableLine: aCollection [

	aCollection do: [ :item |
		report
			<< '| ' ;
			<< item ;
			space
	].
	report
		<< '|' ;
		cr
]

{ #category : 'microdown' }
MiModelReporterModel >> title: aString [

	^self headerBlock: 1 header: aString.

]

{ #category : 'running' }
MiModelReporterModel >> updateReport [

	report := String new writeStream .
	self document.
	report close.
	browser updateReport: report contents
]

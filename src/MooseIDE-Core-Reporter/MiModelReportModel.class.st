"
The spec model for the `MiModelReport`

Responsible for actually generating the report
"
Class {
	#name : #MiModelReportModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'mooseModel',
		'settings',
		'report'
	],
	#category : #'MooseIDE-Core-Reporter'
}

{ #category : #microdown }
MiModelReportModel >> bulletList: aCollection [

	aCollection do: [ :line |
		report
			<< '- ' ;
			<< line ;
			cr
	].
	report cr
]

{ #category : #document }
MiModelReportModel >> classMembersStats: columns [

	self stats: columns compute: [ :c | c numberOfAttributes ] description: 'FIELDS'.
	self stats: columns compute: [ :c | c numberOfMethods ]    description: 'METHODS'
]

{ #category : #settings }
MiModelReportModel >> complexMethodLimit [

	^ settings getItemValue: #complexMethodSetting
]

{ #category : #settings }
MiModelReportModel >> dataClassLimit [

	^ settings getItemValue: #dataClassSetting
]

{ #category : #document }
MiModelReportModel >> document [
		
	self title: ('Dashboard : '  , mooseModel name).

	self sectionPackages.
	self sectionClasses.
	self sectionMethods.

]

{ #category : #accessing }
MiModelReportModel >> entities [
	^mooseModel
]

{ #category : #settings }
MiModelReportModel >> excessiveAPIMethodLimit [

	^ settings getItemValue: #excessiveAPIMethodLimit
]

{ #category : #'api - export' }
MiModelReportModel >> exportReportToHTML: microdownText [

	| filename |
	filename := mooseModel name , '-report.html'.
	filename asFileReference writeStreamDo: [ :stream |
		stream nextPutAll: (MicHTMLVisitor asHTMLString: microdownText)
	].
	browser inform: filename , ' generated', String cr , '(in Pharo image directory)'
]

{ #category : #'api - export' }
MiModelReportModel >> exportReportToPDF: microdownText [

	browser inform: 'PDF export not implemented yet, sorry'
]

{ #category : #'private - formatting' }
MiModelReportModel >> floatAsString: aFloat [

	^(aFloat asFloat round: 1) asString

]

{ #category : #accessing }
MiModelReportModel >> followEntity: aMooseEntity [

	mooseModel := (aMooseEntity isMooseModel ifTrue: [ aMooseEntity ] ifFalse: [ aMooseEntity mooseModel ]).
	self updateReport
]

{ #category : #'private - formatting' }
MiModelReportModel >> formatCollection: collection value: valueBlock [

	^collection
		ifEmpty: [ 'n/a' ]
		ifNotEmpty: [ self floatAsString: (valueBlock value: collection) ]
]

{ #category : #'private - formatting' }
MiModelReportModel >> fullyQualifiedName: anEntity [

	^anEntity mooseName copyReplaceAll: '::' with: '.' 

]

{ #category : #microdown }
MiModelReportModel >> headerBlock: level header: aString [

	level timesRepeat: [ report << '#' ].
	report
		space ;
		<< aString ;
		cr ; cr
]

{ #category : #settings }
MiModelReportModel >> initializeClassSettings [

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
			setValue: 10 ;
			label: 'Data class' ;
			help: 'Above this number of attribute, a class is considered to be a Data class' ;
			yourself)
		named: #dataClassSetting
]

{ #category : #settings }
MiModelReportModel >> initializeMethodSettings [

	settings 
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
		named: #complexMethodSetting ;

		addItem: (MiTextSettingItem integerSetting
			setValue: 5 ;
			label: 'excessive API method' ;
			help: 'Above this number of parameters, a method is considered to have an excessive API' ;
		yourself)
		named: #excessiveAPIMethodLimit.


]

{ #category : #settings }
MiModelReportModel >> initializeSettings [ 

	settings := super initializeSettings.
	self initializeClassSettings.
	self initializeMethodSettings.

]

{ #category : #settings }
MiModelReportModel >> largeClassLimit [

	^ settings getItemValue: #largeClassSetting
]

{ #category : #microdown }
MiModelReportModel >> line: aString [

	report
		<< aString ;
		cr

]

{ #category : #settings }
MiModelReportModel >> longClassLimit [

	^ settings getItemValue: #longClassSetting
]

{ #category : #settings }
MiModelReportModel >> longMethodLimit [

	^ settings getItemValue: #longMethodSetting
]

{ #category : #document }
MiModelReportModel >> methodMembersStats: columns [

	self stats: columns compute: [ :m | m numberOfParameters ] description: 'PARAMETERS'.
	self stats: columns compute: [ :m | m numberOfLinesOfCode ]    description: 'LINES OF CODE'.
	self stats: columns compute: [ :m | m cyclomaticComplexity ]    description: 'CYCLOMATIC COMPLEXITY'
]

{ #category : #accessing }
MiModelReportModel >> miSelectedItem [

	^#()
]

{ #category : #'private - formatting' }
MiModelReportModel >> numericValue: text value: number [

	^text , ': ' , number asString
		
]

{ #category : #accessing }
MiModelReportModel >> reportDOM [

	^ report
]

{ #category : #'api - export' }
MiModelReportModel >> saveRawReport: microdownText [

	| filename |
	filename := mooseModel name , '-report.md'.
	filename asFileReference writeStreamDo: [ :stream |
		stream nextPutAll: microdownText
	].
	browser inform: filename , ' saved', String cr , '(in Pharo image directory)'
]

{ #category : #document }
MiModelReportModel >> sectionClasses [

	| allClasses largeClasses longClasses dataClasses |

	allClasses := OrderedCollection withAll: mooseModel allModelClasses.
	largeClasses := allClasses select: [ :c | c numberOfMethods > self largeClassLimit ].
	longClasses := allClasses select: [ :c | c numberOfLinesOfCode > self longClassLimit ].
	dataClasses := allClasses select: [ :c | c numberOfAttributes > self dataClassLimit ].

	self subtitle: 'Classes'.

	"Stats table"
	self tableHeader: #( '' All Large Long Data ).
	self statLine: { allClasses size asString . largeClasses size asString . longClasses size asString . dataClasses size asString } description: 'number'.
	self classMembersStats: { allClasses . largeClasses . longClasses . dataClasses }.

	"Lists of entities"
	self
		subSectionSpecialList: largeClasses
		description: 'Large classes (> ' , self largeClassLimit asString , ' methods)'.
	self
		subSectionSpecialList: longClasses
		description: 'Long classes (> ' , self longClassLimit asString , ' LOC)'.
	self
		subSectionSpecialList: dataClasses
		description: 'Data classes (> ' , self dataClassLimit asString , ' fields)'.

]

{ #category : #document }
MiModelReportModel >> sectionMethods [

	| allMethods longMethods complexMethods excessiveAPIMethods |

	allMethods := OrderedCollection withAll: mooseModel allModelMethods.
	longMethods := allMethods select: [ :m | m numberOfLinesOfCode > self longMethodLimit ].
	complexMethods := allMethods select: [ :m | m cyclomaticComplexity > self complexMethodLimit ].
	excessiveAPIMethods := allMethods select: [ :m | m numberOfParameters > self excessiveAPIMethodLimit ].
	self subtitle: 'Methods'.

	"Stats table"
	self tableHeader: { '' . 'All' . 'Long' . 'Complex' . 'Excessive API'}.
	self statLine: { allMethods size asString . longMethods size asString . complexMethods size asString . excessiveAPIMethods size asString } description: 'number'.
	self methodMembersStats: { allMethods . longMethods . complexMethods . excessiveAPIMethods }.
	self line: ''.

	"Lists of entities"
	self
		subSectionSpecialList: longMethods
		description: 'Long methods (> ' , self longMethodLimit asString , ' LOC)'.
	self
		subSectionSpecialList: complexMethods
		description: 'Complex methods (cyclomatic complexity > ' , self complexMethodLimit asString , ')'.
	self
		subSectionSpecialList: excessiveAPIMethods
		description: 'Excessive API methods (> ' , self excessiveAPIMethodLimit asString , ' parameters)'
]

{ #category : #document }
MiModelReportModel >> sectionMethodsStats: methods [

	self stats: (methods collect: [ :c | c numberOfParameters ]) description: 'parameters'.
	self stats: (methods collect: [ :c | c numberOfLinesOfCode ]) description: 'lines of code'.
	self stats: (methods collect: [ :c | c cyclomaticComplexity ]) description: 'cyclomatic complexity'

]

{ #category : #document }
MiModelReportModel >> sectionPackages [
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

{ #category : #settings }
MiModelReportModel >> settings [

	^settings
]

{ #category : #settings }
MiModelReportModel >> settingsChanged: aBoolean [

	aBoolean ifTrue: [ self updateReport ].
]

{ #category : #microdown }
MiModelReportModel >> statLine: columns	description: aString [

	self tableLine: { aString } , columns
]

{ #category : #microdown }
MiModelReportModel >> stats: columns compute: valueBlock description: aString [
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

{ #category : #document }
MiModelReportModel >> subSectionSpecialList: collection description: aString [

	self subsubtitle: aString.

	self line: (self numericValue: 'Number' value: collection size).

	self bulletList: ((collection collect: [:c | self fullyQualifiedName: c ])
		sorted: [:a :b | a mooseName < b mooseName]).

]

{ #category : #document }
MiModelReportModel >> subSectionSpecialMethods: selectionBlock description: aString [

	| methods |
	self subsubtitle: aString.

	methods := (mooseModel allModelMethods select: selectionBlock)
		sorted: [:a :b | a mooseName < b mooseName].

	self line: (self numericValue: 'Number' value: methods size).
	self bulletList: (methods collect: [:c | self fullyQualifiedName: c ] ).

	self sectionMethodsStats: methods 

]

{ #category : #microdown }
MiModelReportModel >> subsubtitle: aString [

	^self headerBlock: 3 header: aString.

]

{ #category : #microdown }
MiModelReportModel >> subtitle: aString [

	^self headerBlock: 2 header: aString.

]

{ #category : #microdown }
MiModelReportModel >> tableHeader: aCollection [

	self tableLine: aCollection.
	report
		<< '|---|' ;
		cr
]

{ #category : #microdown }
MiModelReportModel >> tableLine: aCollection [

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

{ #category : #microdown }
MiModelReportModel >> title: aString [

	^self headerBlock: 1 header: aString.

]

{ #category : #running }
MiModelReportModel >> updateReport [

	report := String new writeStream .
	self document.
	report close.
	browser generatedReport: report contents
]

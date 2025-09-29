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
		'report',
		'largeClassThreshold',
		'longClassThreshold',
		'dataClassThreshold',
		'longMethodThreshold',
		'complexMethodThreshold',
		'excessiveAPIThreshold'
	],
	#category : #'MooseIDE-Core-Reporter'
}

{ #category : #'as yet unclassified' }
MiModelReportModel class >> defaultComplexMethodThreshold [

	^ 50
]

{ #category : #accessing }
MiModelReportModel class >> defaultConfiguration [

	^ MiModelReportSettingsConfiguration new
		  largeClassThreshold: self defaultLargeClassThreshold;
		  longClassThreshold: self defaultLongClassThreshold;
		  dataClassThreshold: self defaultDataClassThreshold;
		  longMethodThreshold: self defaultLongMethodThreshold;
		  complexMethodThreshold: self defaultComplexMethodThreshold;
		  excessiveAPIThreshold: self defaultExcessiveAPIThreshold;
		  yourself
]

{ #category : #'as yet unclassified' }
MiModelReportModel class >> defaultDataClassThreshold [

	^ 10
]

{ #category : #'as yet unclassified' }
MiModelReportModel class >> defaultExcessiveAPIThreshold [

	^ 5
]

{ #category : #'as yet unclassified' }
MiModelReportModel class >> defaultLargeClassThreshold [

	^ 100
]

{ #category : #'as yet unclassified' }
MiModelReportModel class >> defaultLongClassThreshold [

	^ 1000
]

{ #category : #'as yet unclassified' }
MiModelReportModel class >> defaultLongMethodThreshold [

	^ 100
]

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

{ #category : #'settings management' }
MiModelReportModel >> currentConfiguration [

	^ MiModelReportSettingsConfiguration new
		  largeClassThreshold: largeClassThreshold;
		  longClassThreshold: longClassThreshold;
		  dataClassThreshold: dataClassThreshold;
		  longMethodThreshold: longMethodThreshold;
		  complexMethodThreshold: complexMethodThreshold;
		  excessiveAPIThreshold: excessiveAPIThreshold;
		  yourself
]

{ #category : #accessing }
MiModelReportModel >> defaultConfiguration [

	^ self class defaultConfiguration
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

{ #category : #'api - export' }
MiModelReportModel >> exportReportToHTML: microdownText [

	| filename |
	filename := mooseModel name , '-report.html'.
	filename asFileReference writeStreamDo: [ :stream |
		stream nextPutAll: (MicHTMLVisitor asHTMLString: microdownText) ].
	browser inform:
		filename , ' generated' , String cr , '(in Pharo image directory)'
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

{ #category : #testing }
MiModelReportModel >> hasSettings [

	^ true
]

{ #category : #microdown }
MiModelReportModel >> headerBlock: level header: aString [

	level timesRepeat: [ report << '#' ].
	report
		space ;
		<< aString ;
		cr ; cr
]

{ #category : #initialization }
MiModelReportModel >> initializeSettings [

	largeClassThreshold := self class defaultLargeClassThreshold.
	longClassThreshold := self class defaultLongClassThreshold.
	dataClassThreshold := self class defaultDataClassThreshold.
	longMethodThreshold := self class defaultLongMethodThreshold.
	complexMethodThreshold := self class defaultComplexMethodThreshold.
	excessiveAPIThreshold := self class defaultExcessiveAPIThreshold
]

{ #category : #microdown }
MiModelReportModel >> line: aString [

	report
		<< aString ;
		cr

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
	largeClasses := allClasses select: [ :c |
		                c numberOfMethods > largeClassThreshold ].
	longClasses := allClasses select: [ :c |
		               c numberOfLinesOfCode > longClassThreshold ].
	dataClasses := allClasses select: [ :c |
		               c numberOfAttributes > dataClassThreshold ].

	self subtitle: 'Classes'.

	"Stats table"
	self tableHeader: #( '' All Large Long Data ).
	self
		statLine: {
				allClasses size asString.
				largeClasses size asString.
				longClasses size asString.
				dataClasses size asString }
		description: 'number'.
	self classMembersStats: {
			allClasses.
			largeClasses.
			longClasses.
			dataClasses }.

	"Lists of entities"
	self
		subSectionSpecialList: largeClasses
		description:
		'Large classes (> ' , largeClassThreshold asString , ' methods)'.
	self
		subSectionSpecialList: longClasses
		description:
		'Long classes (> ' , longClassThreshold asString , ' LOC)'.
	self
		subSectionSpecialList: dataClasses
		description:
		'Data classes (> ' , dataClassThreshold asString , ' fields)'
]

{ #category : #document }
MiModelReportModel >> sectionMethods [

	| allMethods longMethods complexMethods excessiveAPIMethods |
	allMethods := OrderedCollection withAll: mooseModel allModelMethods.
	longMethods := allMethods select: [ :m |
		               m numberOfLinesOfCode > longMethodThreshold ].
	complexMethods := allMethods select: [ :m |
		                  m cyclomaticComplexity > complexMethodThreshold ].
	excessiveAPIMethods := allMethods select: [ :m |
		                       m numberOfParameters > excessiveAPIThreshold ].
	self subtitle: 'Methods'.

	"Stats table"
	self tableHeader: { ''. 'All'. 'Long'. 'Complex'. 'Excessive API' }.
	self
		statLine: {
				allMethods size asString.
				longMethods size asString.
				complexMethods size asString.
				excessiveAPIMethods size asString }
		description: 'number'.
	self methodMembersStats: {
			allMethods.
			longMethods.
			complexMethods.
			excessiveAPIMethods }.
	self line: ''.

	"Lists of entities"
	self
		subSectionSpecialList: longMethods
		description:
		'Long methods (> ' , longMethodThreshold asString , ' LOC)'.
	self
		subSectionSpecialList: complexMethods
		description: 'Complex methods (cyclomatic complexity > '
			, complexMethodThreshold asString , ')'.
	self
		subSectionSpecialList: excessiveAPIMethods
		description:
			'Excessive API methods (> ' , excessiveAPIThreshold asString
			, ' parameters)'
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
MiModelReportModel >> settingsChanged: aBoolean [

	aBoolean ifTrue: [ self updateReport ].
]

{ #category : #'settings management' }
MiModelReportModel >> settingsPresenterExtent [

	^ 425 @ 350
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

{ #category : #'settings management' }
MiModelReportModel >> updateFromConfiguration: aConfiguration [

	largeClassThreshold := aConfiguration largeClassThreshold.
	longClassThreshold := aConfiguration longClassThreshold.
	dataClassThreshold := aConfiguration dataClassThreshold.

	longMethodThreshold := aConfiguration longMethodThreshold.
	complexMethodThreshold := aConfiguration complexMethodThreshold.
	excessiveAPIThreshold := aConfiguration excessiveAPIThreshold.

	mooseModel ifNil: [ ^ self ].
	self updateReport
]

{ #category : #running }
MiModelReportModel >> updateReport [

	report := String new writeStream .
	self document.
	report close.
	browser generatedReport: report contents
]

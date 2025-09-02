Class {
	#name : 'MiModelReportMemento',
	#superclass : 'MiMemento',
	#instVars : [
		'largeClassThreshold',
		'longClassThreshold',
		'dataClassThreshold',
		'longMethodThreshold',
		'complexMethodThreshold',
		'excessiveAPIThreshold'
	],
	#category : 'MooseIDE-Core-Reporter',
	#package : 'MooseIDE-Core-Reporter'
}

{ #category : 'accessing' }
MiModelReportMemento >> complexMethodThreshold [

	^ complexMethodThreshold
]

{ #category : 'accessing' }
MiModelReportMemento >> complexMethodThreshold: anObject [

	complexMethodThreshold := anObject
]

{ #category : 'accessing' }
MiModelReportMemento >> dataClassThreshold [

	^ dataClassThreshold
]

{ #category : 'accessing' }
MiModelReportMemento >> dataClassThreshold: anObject [

	dataClassThreshold := anObject
]

{ #category : 'accessing' }
MiModelReportMemento >> excessiveAPIThreshold [

	^ excessiveAPIThreshold
]

{ #category : 'accessing' }
MiModelReportMemento >> excessiveAPIThreshold: anObject [

	excessiveAPIThreshold := anObject
]

{ #category : 'accessing' }
MiModelReportMemento >> largeClassThreshold [

	^ largeClassThreshold
]

{ #category : 'accessing' }
MiModelReportMemento >> largeClassThreshold: anObject [

	largeClassThreshold := anObject
]

{ #category : 'accessing' }
MiModelReportMemento >> longClassThreshold [

	^ longClassThreshold
]

{ #category : 'accessing' }
MiModelReportMemento >> longClassThreshold: anObject [

	longClassThreshold := anObject
]

{ #category : 'accessing' }
MiModelReportMemento >> longMethodThreshold [

	^ longMethodThreshold
]

{ #category : 'accessing' }
MiModelReportMemento >> longMethodThreshold: anObject [

	longMethodThreshold := anObject
]

{ #category : 'ui' }
MiModelReportMemento >> settingsPresenters [

	^ OrderedCollection new
		  add: ((MiNumberSettingPresenter on: self)
				   number: largeClassThreshold;
				   unit: 'nb of methods';
				   label: 'Large class threshold:';
				   help:
					   'Above this number of methods, a class is considered large';
				   yourself);
		  add: ((MiNumberSettingPresenter on: self)
				   number: longClassThreshold;
				   unit: 'LOC';
				   label: 'Long class threshold:';
				   help:
					   'Above this number of lines of code, a class is considered long';
				   yourself);
		  add: ((MiNumberSettingPresenter on: self)
				   number: dataClassThreshold;
				   unit: 'nb of attributes';
				   label: 'Data class threshold:';
				   help:
					   'Above this number of attribute, a class is considered to be a Data class';
				   yourself);
		  add: ((MiNumberSettingPresenter on: self)
				   number: longMethodThreshold;
				   unit: 'LOC';
				   label: 'Long method threshold:';
				   help:
					   'Above this number of lines of code, a method is considered long';
				   yourself);
		  add: ((MiNumberSettingPresenter on: self)
				   number: complexMethodThreshold;
				   unit: 'cyclomatic complexity';
				   label: 'Complex method threshold:';
				   help:
					   'Above this cyclomatic complexity, a method is considered complex';
				   yourself);
		  add: ((MiNumberSettingPresenter on: self)
				   number: excessiveAPIThreshold;
				   unit: 'nb of parameters';
				   label: 'Excessive API threshold:';
				   help:
					   'Above this number of parameters, a method is considered to have an excessive API';
				   yourself);
		  yourself
]

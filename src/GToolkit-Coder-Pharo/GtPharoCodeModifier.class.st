"
Pharo does not support code modification from multiple threads, although it is not forbidden.
${class:GtPharoCodeModifier}$ allows synchronisation of code modifications via a mutex.

All Pharo code changes should happen via this class
"
Class {
	#name : #GtPharoCodeModifier,
	#superclass : #Object,
	#instVars : [
		'monitor'
	],
	#classInstVars : [
		'current'
	],
	#category : #'GToolkit-Coder-Pharo-Coders'
}

{ #category : #'api - method' }
GtPharoCodeModifier class >> compileMethodSource: aSourceCode in: aClass protocol: aMethodProtocol [
	^ self current compileMethodSource: aSourceCode in: aClass protocol: aMethodProtocol
]

{ #category : #'api - package' }
GtPharoCodeModifier class >> createPackageNamed: aPackageName [
	^ self current createPackageNamed: aPackageName
]

{ #category : #accessing }
GtPharoCodeModifier class >> current [
	^ current ifNil: [ current := self new ]
]

{ #category : #'api - class' }
GtPharoCodeModifier class >> removeBehavior: aBehavior [
	^ self current removeBehavior: aBehavior
]

{ #category : #'api - method' }
GtPharoCodeModifier class >> removeMethod: aCompiledMethod [
	^ self current removeMethod: aCompiledMethod
]

{ #category : #'api - package' }
GtPharoCodeModifier class >> removePackage: aPackage [
	^ self current removePackage: aPackage
]

{ #category : #'api - method' }
GtPharoCodeModifier >> compileMethodSource: aSourceCode in: aClass protocol: aMethodProtocol [
	^ self critical: [
		aClass
			compile:aSourceCode
			classified: aMethodProtocol ]
]

{ #category : #'api - package' }
GtPharoCodeModifier >> createPackageNamed: aPackageName [
	^ self critical: [ RPackageOrganizer default createPackageNamed: aPackageName ]
]

{ #category : #'api - class' }
GtPharoCodeModifier >> createSubclassOf: anExistingClass named: aSubclassName instanceVariableNames: instVarNameList classVariableNames: classVarNames package: aPackageSymbol [
	^ self critical: [
		anExistingClass
			subclass:aSubclassName
			instanceVariableNames: instVarNameList
			classVariableNames: classVarNames
			package: aPackageSymbol ]
]

{ #category : #'api - class' }
GtPharoCodeModifier >> createSubclassOf: anExistingClass named: aSubclassName instanceVariableNames: instVarNameList package: aPackageSymbol [
	^ self 
		createSubclassOf: anExistingClass
		named: aSubclassName
		instanceVariableNames: instVarNameList
		classVariableNames: ''
		package: aPackageSymbol
]

{ #category : #'mutual exclusion' }
GtPharoCodeModifier >> critical: aBlock [
	^ monitor critical: [
		aBlock
			on: Exception
			do: [ :anException |
				"it is very important that the monitor is not locked when an exception happens"
				monitor exit.
				anException pass ] ]
]

{ #category : #initialization }
GtPharoCodeModifier >> initialize [
	super initialize.
	
	monitor := Monitor new
]

{ #category : #'api - refactoring' }
GtPharoCodeModifier >> performRefactoryChange: aRefactoryChange [
	^ self critical: [ RBRefactoryChangeManager instance performChange: aRefactoryChange ]
]

{ #category : #'api - class' }
GtPharoCodeModifier >> removeBehavior: aBehavior [
	^ self critical: [ aBehavior removeFromSystem ]
]

{ #category : #'api - class' }
GtPharoCodeModifier >> removeClass: aClass [
	^ self critical: [ aClass removeFromSystem ]
]

{ #category : #'api - method' }
GtPharoCodeModifier >> removeMethod: aMethod [
	^ self critical: [ aMethod removeFromSystem ]
]

{ #category : #'api - method' }
GtPharoCodeModifier >> removeMethodFrom: aBehavior selector: aSelector [
	^ self critical: [ aBehavior removeSelector: aSelector ]
]

{ #category : #'api - package' }
GtPharoCodeModifier >> removePackage: aPackage [
	^ self critical: [ aPackage removeFromSystem ]
]

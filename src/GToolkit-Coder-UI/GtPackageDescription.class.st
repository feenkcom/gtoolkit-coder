Class {
	#name : #GtPackageDescription,
	#superclass : #Object,
	#instVars : [
		'package',
		'packageName',
		'tag'
	],
	#category : #'GToolkit-Coder-UI-Forms - Models'
}

{ #category : #'instance creation' }
GtPackageDescription class >> forPackage: aPackage [
	^ self new package: aPackage
]

{ #category : #initialization }
GtPackageDescription >> initialize [
	tag := ''
]

{ #category : #accessing }
GtPackageDescription >> package [

	^ package
]

{ #category : #accessing }
GtPackageDescription >> package: aPackage [
	package := aPackage.
	packageName := aPackage name.
]

{ #category : #magritte }
GtPackageDescription >> packageDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Package';
		priority: 1;
		accessor: #packageName;
		blocCompletion: [ GtStringsCompletionStrategy new
				completions: (GtPrefixTree withAll: RPackageOrganizer default packageNames) ];
		addCondition: [ :aValue | (RPackageOrganizer default packageNamed: aValue ifAbsent: [ nil ]) isNil ]
			labelled: 'Package exists'
]

{ #category : #accessing }
GtPackageDescription >> packageName [

	^ packageName
]

{ #category : #accessing }
GtPackageDescription >> packageName: anObject [

	packageName := anObject
]

{ #category : #accessing }
GtPackageDescription >> tag [

	^ tag
]

{ #category : #accessing }
GtPackageDescription >> tag: aTagName [
	tag := aTagName
]

{ #category : #magritte }
GtPackageDescription >> tagDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Tag';
		priority: 2;
		accessor: #tag;	
		blocCompletion: [ GtStringsCompletionStrategy new
				completions: (GtPrefixTree withAll: (packageName asPackage classTags collect: #name)) ];
		addCondition: [ :aValue | (package classTagNamed: aValue ifAbsent: [ nil ]) isNil ]
			labelled: 'Tag exists'
]

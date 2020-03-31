Class {
	#name : #GtPackageDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'name'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #'instance creation' }
GtPackageDefinition class >> fromBehavior: aBehavior [
	^ self new fromBehavior: aBehavior
]

{ #category : #'instance creation' }
GtPackageDefinition class >> fromPackage: anRPackage [
	^ self new fromPackage: anRPackage
]

{ #category : #'gt - editors' }
GtPackageDefinition >> editors [
	^ { self packageEditor }
]

{ #category : #initialization }
GtPackageDefinition >> fromBehavior: aBehavior [
	name := aBehavior package name
]

{ #category : #initialization }
GtPackageDefinition >> fromPackage: anRPackage [
	name := anRPackage name
]

{ #category : #initialization }
GtPackageDefinition >> initialize [
	super initialize.
]

{ #category : #accessing }
GtPackageDefinition >> name [
	^ name
]

{ #category : #accessing }
GtPackageDefinition >> name: aSymbol [
	name := aSymbol asSymbol
]

{ #category : #'gt - editors' }
GtPackageDefinition >> packageEditor [
	^ GtCodeDefinitionSingleEditor new
		title: 'Package';
		definition: self;
		getSelector: #name;
		completion: [ GtPackagesCompletionStrategy new ]
]

Class {
	#name : #GtPackageDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'name'
	],
	#category : #'GToolkit-Coder-Behavior - Definitions'
}

{ #category : #'instance creation' }
GtPackageDefinition class >> fromBehavior: aBehavior [
	^ self new fromBehavior: aBehavior
]

{ #category : #converting }
GtPackageDefinition >> asDefinitionString [
	^ self name
]

{ #category : #'api - package' }
GtPackageDefinition >> browseFrom: anEvent [
	| aRealPackage |

	aRealPackage := RPackageOrganizer default
		packageNamed: self name
		ifAbsent: [ ^ self ].
		
	anEvent currentTarget phlow spawnObject: aRealPackage
]

{ #category : #'api - accepting' }
GtPackageDefinition >> differenceWith: aPackageDefinition [
	<return: #GtCodeDefinitionDifference>
	
	^ self name = aPackageDefinition name
		ifTrue: [ GtNoDefinitionDifference new ]
		ifFalse: [ GtPackageDefinitionDifference new
			oldName: aPackageDefinition name;
			newName: self name ]
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
		setSelector: #name:;
		completion: [ GtPackagesCompletionStrategy new ];
		whenKey: BlKeyCombination primaryB do: [ :anEvent :aDefinition  | aDefinition browseFrom: anEvent ];
		whenPrimaryClickDo: [ :anEvent :aDefinition | aDefinition browseFrom: anEvent ]
]

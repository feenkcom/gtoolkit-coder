Class {
	#name : #GtPackageDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'name',
		'originalName'
	],
	#category : #'GToolkit-Coder-Behavior - Definitions'
}

{ #category : #'instance creation' }
GtPackageDefinition class >> empty [
	^ self new empty
]

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
GtPackageDefinition >> empty [
	name := #''.
	originalName := name
]

{ #category : #initialization }
GtPackageDefinition >> fromBehavior: aBehavior [
	name := aBehavior package name.
	originalName := name
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
	| anOldName |
	
	anOldName := name.
	name := aSymbol asSymbol.

	name = anOldName
		ifTrue: [ ^ self ].

	self
		notifyPackageRenamed: self
		from: anOldName
		to: name
]

{ #category : #'private - notifying' }
GtPackageDefinition >> notifyPackageRenamed: aGtPackageDefinition from: anOldName to: aNewName [
	self dispatchEvent: (GtBehaviorPackageRenamed new
		owner: self parent;
		package: aGtPackageDefinition;
		oldName: anOldName;
		newName: aNewName)
]

{ #category : #accessing }
GtPackageDefinition >> originalName [
	^ originalName
]

{ #category : #'gt - editors' }
GtPackageDefinition >> packageEditor [
	^ GtCodeDefinitionSingleEditor new
		title: 'Package';
		definition: self;
		getSelector: #name;
		setSelector: #name:;
		renameEvent: GtBehaviorPackageRenamed;
		completion: [ GtPackagesCompletionStrategy new ];
		whenKey: BlKeyCombination primaryB do: [ :anEvent :aDefinition  | aDefinition browseFrom: anEvent ];
		whenPrimaryClickDo: [ :anEvent :aDefinition | aDefinition browseFrom: anEvent ]
]

{ #category : #'gt - editors' }
GtPackageDefinition >> packageReader [
	^ GtCodeDefinitionSingleReader new
		title: 'Package';
		definition: self;
		getSelector: #name;
		renameEvent: GtBehaviorPackageRenamed;
		completion: [ GtPackagesCompletionStrategy new ];
		whenKey: BlKeyCombination primaryB do: [ :anEvent :aDefinition  | aDefinition browseFrom: anEvent ];
		whenPrimaryClickDo: [ :anEvent :aDefinition | aDefinition browseFrom: anEvent ]
]

{ #category : #'gt - editors' }
GtPackageDefinition >> readers [
	^ { self packageReader }
]

Extension { #name : #Trait }

{ #category : #'*GToolkit-Coder-UI' }
Trait >> gtCoderSidebarIndexBrowseTraitUsersFor: anAction [
	<gtAction>
	self isTrait ifFalse: [ ^ anAction noAction ].

	^ anAction button
		priority: 3;
		target: GtCoderClassTarget;
		icon: BrGlamorousVectorIcons empty;
		label: 'Browse trait users';
		menuItemPreview: self name;
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton | aButton phlow spawnObject: (self instanceSide users asArray sort: [ :a | a name ] ascending) ]
]

{ #category : #'*GToolkit-Coder-UI' }
Trait >> gtCoderTypeName [
	^ 'trait'
]

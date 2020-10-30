Extension { #name : #GtCodeDefinition }

{ #category : #'*GToolkit-Coder-Extensions' }
GtCodeDefinition >> gtDefinitionFor: aView [
	<gtView>

	^ aView textEditor
		title: 'Definition';
		priority: 1;
		text: [ self asDefinitionString ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtCodeDefinition >> gtEditorsFor: aView [
	<gtView>
	
	self editors
		ifEmpty: [ ^ aView empty ].
	
	^ aView list
		title: 'Editors';
		priority: 8;
		items: [ self editors ]
]

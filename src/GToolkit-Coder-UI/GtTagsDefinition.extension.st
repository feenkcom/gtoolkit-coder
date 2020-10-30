Extension { #name : #GtTagsDefinition }

{ #category : #'*GToolkit-Coder-UI' }
GtTagsDefinition >> editors [
	^ { self tagsEditor }
]

{ #category : #'*GToolkit-Coder-UI' }
GtTagsDefinition >> tagsEditor [
	<return: #GtCodeDefinitionViewer>
	
	^ GtCodeDefinitionPluralEditor new
		title: 'Tags';
		definition: self;
		addSelector: #addTagNamed:;
		removeSelector: #removeTagNamed:;
		renameSelector: #renameTagNamed:to:;
		getSelector: #names;
		addEvent: GtBehaviorTagAdded;
		removeEvent: GtBehaviorTagRemoved;
		renameEvent: GtBehaviorTagRenamed;
		separator: [
			BrLabel new
				look: (BrGlamorousLabelLook new glamorousCodeFontAndSmallSize foreground: BrGlamorousColors defaultButtonTextColor );
				text: ',' ]
]

Extension { #name : #GtSearchFilter }

{ #category : #'*GToolkit-SearchFilters-PhlowTool' }
GtSearchFilter >> gtDefaultInspectorTool [
	^ GtPhlowCompositeTool new
		addTool: (GtPhlowSearchFilterTool forSearchFilter: self);
		addTool: (super gtDefaultInspectorTool)
]

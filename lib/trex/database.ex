use Amnesia

defdatabase Trex.Database do
  deftable Translation, [:key, :value], type: :ordered_set do
    @type t :: Translation[key: String.t, value: String.t]
  end
end

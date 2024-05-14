abstract class QuickFormConverter<TModel, TFormModel> {
  TFormModel toFormModel(TModel model);
  TModel toModel(TFormModel formModel);
}

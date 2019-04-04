using Autofac;
using ExtractProgramSchedule.Repository;

namespace ExtractProgramSchedule
{
	internal static class ServiceLocator
	{
		static IContainer _container;

		public static void Initialize()
		{
			var builder = new ContainerBuilder();
			builder.RegisterType<DataRepository>().As<IDataRepository>();
			_container = builder.Build();
		}

		public static T Resolve<T>()
		{
			return _container.Resolve<T>();
		}
	}
}
